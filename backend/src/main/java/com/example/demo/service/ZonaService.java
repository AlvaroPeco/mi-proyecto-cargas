package com.example.demo.service;

import com.example.demo.entity.Zona;
import com.example.demo.repository.ZonaRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ZonaService {

    private final ZonaRepository zonaRepository;

    public ZonaService(ZonaRepository zonaRepository) {
        this.zonaRepository = zonaRepository;
    }

    public List<Zona> obtenerTodas() {
        return zonaRepository.findAll();
    }

    public Zona obtenerPorId(Integer id) {
        return zonaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Zona no encontrada"));
    }
}