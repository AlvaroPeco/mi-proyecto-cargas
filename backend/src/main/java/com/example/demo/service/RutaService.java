package com.example.demo.service;

import com.example.demo.entity.Ruta;
import com.example.demo.repository.RutaRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RutaService {

    private final RutaRepository rutaRepository;

    public RutaService(RutaRepository rutaRepository) {
        this.rutaRepository = rutaRepository;
    }

    public List<Ruta> obtenerTodas() {
        return rutaRepository.findAll();
    }

    public Ruta obtenerPorId(Integer id) {
        return rutaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Ruta no encontrada"));
    }
}
