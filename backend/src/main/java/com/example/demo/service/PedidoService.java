package com.example.demo.service;

import com.example.demo.entity.Palet;
import com.example.demo.entity.Pedido;
import com.example.demo.repository.PedidoRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PedidoService {

    private final PedidoRepository pedidoRepository;

    public PedidoService(PedidoRepository pedidoRepository) {
        this.pedidoRepository = pedidoRepository;
    }

    public List<Pedido> obtenerTodos() {
        return pedidoRepository.findAll();
    }

    public Pedido obtenerPorId(Integer id) {
        return pedidoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));
    }

    public List<Pedido> obtenerPorPalet(Palet palet) {
        return pedidoRepository.findByPalet(palet);
    }
}
