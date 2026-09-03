package com.example.demo.controller;

import com.example.demo.entity.Zona;
import com.example.demo.service.ZonaService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/zonas")
@CrossOrigin(origins = "http://localhost:5173")
public class ZonaController {

    private final ZonaService zonaService;

    public ZonaController(ZonaService zonaService) {
        this.zonaService = zonaService;
    }

    @GetMapping
    public List<Zona> obtenerTodas() {
        return zonaService.obtenerTodas();
    }

    @GetMapping("/{id}")
    public Zona obtenerPorId(@PathVariable Integer id) {
        return zonaService.obtenerPorId(id);
    }
}
