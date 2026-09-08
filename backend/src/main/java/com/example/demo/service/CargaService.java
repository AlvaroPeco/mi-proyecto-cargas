package com.example.demo.service;

import com.example.demo.entity.Carga;
import com.example.demo.entity.EstadoCarga;
import com.example.demo.entity.Palet;
import com.example.demo.entity.Vehiculo;
import com.example.demo.repository.CargaRepository;
import com.example.demo.repository.PaletRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
public class CargaService {

    private final CargaRepository cargaRepository;
    private final PaletRepository paletRepository;

    public CargaService(
            CargaRepository cargaRepository,
            PaletRepository paletRepository) {

        this.cargaRepository = cargaRepository;
        this.paletRepository = paletRepository;
    }

    public List<Carga> obtenerTodas() {
        return cargaRepository.findAll();
    }

    public Carga obtenerPorId(Integer id) {
        return cargaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Carga no encontrada"));
    }

    public List<Carga> obtenerPorVehiculo(Vehiculo vehiculo) {
        return cargaRepository.findByVehiculo(vehiculo);
    }

    public List<Carga> obtenerPorFecha(LocalDate fecha) {
        return cargaRepository.findByFecha(fecha);
    }

    public List<Carga> obtenerPorVehiculoYFecha(
            Vehiculo vehiculo,
            LocalDate fecha) {

        return cargaRepository.findByVehiculoAndFecha(vehiculo, fecha);
    }

    public boolean estanTodosLosPaletsCargados(Integer idCarga) {

        Carga carga = obtenerPorId(idCarga);

        List<Palet> palets = paletRepository.findByCarga(carga);

        if (palets.isEmpty()) {
            return false;
        }

        return palets.stream()
                .allMatch(palet -> palet.getEstado().name().equals("cargado"));
    }

    public Carga marcarComoCargada(Integer idCarga) {

        Carga carga = obtenerPorId(idCarga);

        if (!estanTodosLosPaletsCargados(idCarga)) {
            throw new RuntimeException(
                    "No se puede marcar la carga como cargada porque quedan palés pendientes"
            );
        }

        carga.setEstado(EstadoCarga.cargada);

        return cargaRepository.save(carga);
    }

    @Transactional
    public void sincronizarEstadosDeCargas() {
        List<Carga> cargas = cargaRepository.findAll();

        for (Carga carga : cargas) {
            // Ignoramos las cargas ya finalizadas
            if (carga.getEstado() == EstadoCarga.finalizada) {
                continue;
            }

            List<Palet> palets = paletRepository.findByCarga(carga);

            EstadoCarga estadoCalculado;

            if (palets.isEmpty()) {
                estadoCalculado = EstadoCarga.pendiente;
            } else {
                long paletsCargados = palets.stream()
                        .filter(palet -> palet.getEstado().name().equals("cargado"))
                        .count();

                if (paletsCargados == 0) {
                    estadoCalculado = EstadoCarga.pendiente;
                } else if (paletsCargados < palets.size()) {
                    estadoCalculado = EstadoCarga.en_preparacion;
                } else {
                    estadoCalculado = EstadoCarga.cargada;
                }
            }

            // Actualizamos la base de datos solo si el estado ha cambiado
            if (carga.getEstado() != estadoCalculado) {
                carga.setEstado(estadoCalculado);
                cargaRepository.save(carga);
            }
        }
    }
}