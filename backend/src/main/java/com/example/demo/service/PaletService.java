package com.example.demo.service;

import com.example.demo.entity.Carga;
import com.example.demo.entity.EstadoCarga;
import com.example.demo.entity.EstadoPalet;
import com.example.demo.entity.Palet;
import com.example.demo.entity.Usuario;
import com.example.demo.repository.CargaRepository;
import com.example.demo.repository.PaletRepository;
import com.example.demo.repository.UsuarioRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class PaletService {

    private final PaletRepository paletRepository;
    private final UsuarioRepository usuarioRepository;
    private final CargaRepository cargaRepository;

    // 1. Inyectamos CargaRepository en el constructor
    public PaletService(
            PaletRepository paletRepository, 
            UsuarioRepository usuarioRepository,
            CargaRepository cargaRepository) {
        this.paletRepository = paletRepository;
        this.usuarioRepository = usuarioRepository;
        this.cargaRepository = cargaRepository;
    }

    public List<Palet> obtenerTodos() {
        return paletRepository.findAll();
    }

    public Palet obtenerPorId(Integer id) {
        return paletRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Palé no encontrado"));
    }

    public List<Palet> obtenerPorCarga(Carga carga) {
        return paletRepository.findByCarga(carga);
    }

    public Palet obtenerPorCodigoEscaneo(String codEscaneo) {
        return paletRepository.findByCodEscaneo(codEscaneo)
                .orElseThrow(() -> new RuntimeException("Palé no encontrado"));
    }

    public Palet escanearPalet(String codEscaneo, Long idUsuario) {

        Palet palet = obtenerPorCodigoEscaneo(codEscaneo);

        // 1. Cambiamos el estado
        palet.setEstado(EstadoPalet.cargado);

        // 2. Guardamos la fecha y hora actual del escaneo
        palet.setFechaEscaneo(LocalDateTime.now());

        // 3. Buscamos y asociamos el usuario que realizó el escaneo
        if (idUsuario != null) {
            Usuario usuario = usuarioRepository.findById(idUsuario)
                    .orElseThrow(() -> new RuntimeException("Usuario no encontrado con ID: " + idUsuario));
            palet.setUsuarioEscaneo(usuario);
        }

        // 4. Guardamos el palé
        Palet paletGuardado = paletRepository.save(palet);

        // 5. Actualizamos automáticamente el estado de la Carga asociada
        Carga carga = paletGuardado.getCarga();
        if (carga != null) {
            actualizarEstadoCarga(carga);
        }

        return paletGuardado;
    }

    // 6. Lógica de cálculo según el recuento de palés
    private void actualizarEstadoCarga(Carga carga) {
        List<Palet> paletsDeCarga = paletRepository.findByCarga(carga);

        if (paletsDeCarga.isEmpty()) {
            carga.setEstado(EstadoCarga.pendiente);
        } else {
            long escaneados = paletsDeCarga.stream()
                    .filter(p -> p.getEstado() == EstadoPalet.cargado)
                    .count();

            int total = paletsDeCarga.size();

            if (escaneados == 0) {
                carga.setEstado(EstadoCarga.pendiente);
            } else if (escaneados == total) {
                carga.setEstado(EstadoCarga.cargada);
            } else {
                carga.setEstado(EstadoCarga.en_preparacion);
            }
        }

        cargaRepository.save(carga);
    }
}