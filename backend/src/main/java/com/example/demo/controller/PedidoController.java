package com.example.demo.controller;

import com.example.demo.entity.Palet;
import com.example.demo.entity.Pedido;
import com.example.demo.service.PaletService;
import com.example.demo.service.PedidoService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pedidos")
@CrossOrigin(origins = {"http://localhost:5173", "http://192.168.1.42:5173"}, allowCredentials = "true")
public class PedidoController {

    private final PedidoService pedidoService;
    private final PaletService paletService;

    public PedidoController(
            PedidoService pedidoService,
            PaletService paletService
    ) {
        this.pedidoService = pedidoService;
        this.paletService = paletService;
    }

    @GetMapping
    public List<Pedido> obtenerTodos() {
        return pedidoService.obtenerTodos();
    }

    @GetMapping("/{id}")
    public Pedido obtenerPorId(@PathVariable Integer id) {
        return pedidoService.obtenerPorId(id);
    }

    @GetMapping("/palet/{idPalet}")
    public List<Pedido> obtenerPorPalet(@PathVariable Integer idPalet) {

        Palet palet = paletService.obtenerPorId(idPalet);

        return pedidoService.obtenerPorPalet(palet);
    }
}