package com.example.demo.controller;

import com.example.demo.entity.RutaZona;
import com.example.demo.service.RutaZonaService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ruta-zona")
@CrossOrigin(origins = {"http://localhost:5173", "http://192.168.1.42:5173"}, allowCredentials = "true")
public class RutaZonaController {

    private final RutaZonaService rutaZonaService;

    public RutaZonaController(RutaZonaService rutaZonaService) {
        this.rutaZonaService = rutaZonaService;
    }

    @GetMapping
    public List<RutaZona> obtenerTodas() {
        return rutaZonaService.obtenerTodas();
    }
}
