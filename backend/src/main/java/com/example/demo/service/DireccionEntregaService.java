package com.example.demo.service;

import com.example.demo.entity.DireccionEntrega;
import com.example.demo.repository.DireccionEntregaRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DireccionEntregaService {

    private final DireccionEntregaRepository direccionEntregaRepository;

    public DireccionEntregaService(DireccionEntregaRepository direccionEntregaRepository) {
        this.direccionEntregaRepository = direccionEntregaRepository;
    }

    public List<DireccionEntrega> obtenerTodas() {
        return direccionEntregaRepository.findAll();
    }

    public DireccionEntrega obtenerPorId(Integer id) {
        return direccionEntregaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Dirección de entrega no encontrada"));
    }
}