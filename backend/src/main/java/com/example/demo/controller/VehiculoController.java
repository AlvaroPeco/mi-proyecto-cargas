package com.example.demo.controller;

import com.example.demo.entity.Vehiculo;
import com.example.demo.service.VehiculoService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/vehiculos")
@CrossOrigin(origins = {"http://localhost:5173", "http://192.168.1.42:5173"}, allowCredentials = "true")
public class VehiculoController {

    private final VehiculoService vehiculoService;

    public VehiculoController(VehiculoService vehiculoService) {
        this.vehiculoService = vehiculoService;
    }

    @GetMapping
    public List<Vehiculo> obtenerTodos() {
        return vehiculoService.obtenerTodos();
    }

    @GetMapping("/{id}")
    public Vehiculo obtenerPorId(@PathVariable Integer id) {
        return vehiculoService.obtenerPorId(id);
    }
}
