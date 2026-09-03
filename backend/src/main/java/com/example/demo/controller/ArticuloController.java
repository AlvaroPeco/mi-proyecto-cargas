package com.example.demo.controller;

import com.example.demo.entity.Articulo;
import com.example.demo.service.ArticuloService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/articulos")
@CrossOrigin(origins = "http://localhost:5173")
public class ArticuloController {

    private final ArticuloService articuloService;

    public ArticuloController(ArticuloService articuloService) {
        this.articuloService = articuloService;
    }

    @GetMapping
    public List<Articulo> obtenerTodos() {
        return articuloService.obtenerTodos();
    }

    @GetMapping("/{id}")
    public Articulo obtenerPorId(@PathVariable Integer id) {
        return articuloService.obtenerPorId(id);
    }
}
