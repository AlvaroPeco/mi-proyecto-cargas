package com.example.demo.service;

import com.example.demo.entity.Articulo;
import com.example.demo.repository.ArticuloRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ArticuloService {

    private final ArticuloRepository articuloRepository;

    public ArticuloService(ArticuloRepository articuloRepository) {
        this.articuloRepository = articuloRepository;
    }

    public List<Articulo> obtenerTodos() {
        return articuloRepository.findAll();
    }

    public Articulo obtenerPorId(Integer id) {
        return articuloRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Artículo no encontrado"));
    }
}