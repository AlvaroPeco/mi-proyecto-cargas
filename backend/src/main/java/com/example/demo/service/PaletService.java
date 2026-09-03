package com.example.demo.service;

import com.example.demo.entity.Carga;
import com.example.demo.entity.EstadoPalet;
import com.example.demo.entity.Palet;
import com.example.demo.repository.PaletRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PaletService {

    private final PaletRepository paletRepository;

    public PaletService(PaletRepository paletRepository) {
        this.paletRepository = paletRepository;
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

    public Palet escanearPalet(String codEscaneo) {

        Palet palet = obtenerPorCodigoEscaneo(codEscaneo);

        palet.setEstado(EstadoPalet.cargado);

        return paletRepository.save(palet);
    }
}
