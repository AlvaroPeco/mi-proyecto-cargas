package com.example.demo.controller;

import com.example.demo.entity.Cliente;
import com.example.demo.service.ClienteService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/clientes")
@CrossOrigin(origins = "http://localhost:5173")
public class ClienteController {

    private final ClienteService clienteService;

    public ClienteController(ClienteService clienteService) {
        this.clienteService = clienteService;
    }

    @GetMapping
    public List<Cliente> obtenerTodos() {
        return clienteService.obtenerTodos();
    }

    @GetMapping("/{id}")
    public Cliente obtenerPorId(@PathVariable Integer id) {
        return clienteService.obtenerPorId(id);
    }
}
