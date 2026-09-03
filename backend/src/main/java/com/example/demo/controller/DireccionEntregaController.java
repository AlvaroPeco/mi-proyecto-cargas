package com.example.demo.controller;

import com.example.demo.entity.DireccionEntrega;
import com.example.demo.service.DireccionEntregaService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/direcciones-entrega")
@CrossOrigin(origins = "http://localhost:5173")
public class DireccionEntregaController {

    private final DireccionEntregaService direccionEntregaService;

    public DireccionEntregaController(DireccionEntregaService direccionEntregaService) {
        this.direccionEntregaService = direccionEntregaService;
    }

    @GetMapping
    public List<DireccionEntrega> obtenerTodas() {
        return direccionEntregaService.obtenerTodas();
    }

    @GetMapping("/{id}")
    public DireccionEntrega obtenerPorId(@PathVariable Integer id) {
        return direccionEntregaService.obtenerPorId(id);
    }
}
