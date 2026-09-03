package com.example.demo.repository;

import com.example.demo.entity.Carga;
import com.example.demo.entity.Palet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PaletRepository extends JpaRepository<Palet, Integer> {

    List<Palet> findByCarga(Carga carga);

    Optional<Palet> findByCodEscaneo(String codEscaneo);
}