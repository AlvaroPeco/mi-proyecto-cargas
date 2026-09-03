package com.example.demo.service;

import com.example.demo.entity.RutaZona;
import com.example.demo.repository.RutaZonaRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RutaZonaService {

    private final RutaZonaRepository rutaZonaRepository;

    public RutaZonaService(RutaZonaRepository rutaZonaRepository) {
        this.rutaZonaRepository = rutaZonaRepository;
    }

    public List<RutaZona> obtenerTodas() {
        return rutaZonaRepository.findAll();
    }
}