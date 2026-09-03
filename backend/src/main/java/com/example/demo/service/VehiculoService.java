package com.example.demo.service;

import com.example.demo.entity.Vehiculo;
import com.example.demo.repository.VehiculoRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VehiculoService {

    private final VehiculoRepository vehiculoRepository;

    public VehiculoService(VehiculoRepository vehiculoRepository) {
        this.vehiculoRepository = vehiculoRepository;
    }

    public List<Vehiculo> obtenerTodos() {
        return vehiculoRepository.findAll();
    }

    public Vehiculo obtenerPorId(Integer id) {
        return vehiculoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vehículo no encontrado"));
    }
}
