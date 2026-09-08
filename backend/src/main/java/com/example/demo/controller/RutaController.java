package com.example.demo.controller;

import com.example.demo.entity.Ruta;
import com.example.demo.service.RutaService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/rutas")
@CrossOrigin(origins = {"http://localhost:5173", "http://192.168.1.42:5173"}, allowCredentials = "true")
public class RutaController {

    private final RutaService rutaService;

    public RutaController(RutaService rutaService) {
        this.rutaService = rutaService;
    }

    @GetMapping
    public List<Ruta> obtenerTodas() {
        return rutaService.obtenerTodas();
    }

    @GetMapping("/{id}")
    public Ruta obtenerPorId(@PathVariable Integer id) {
        return rutaService.obtenerPorId(id);
    }
}
