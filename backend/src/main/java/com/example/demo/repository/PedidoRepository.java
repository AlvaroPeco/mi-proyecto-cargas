package com.example.demo.repository;

import com.example.demo.entity.Palet;
import com.example.demo.entity.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PedidoRepository extends JpaRepository<Pedido, Integer> {

    List<Pedido> findByPalet(Palet palet);
}