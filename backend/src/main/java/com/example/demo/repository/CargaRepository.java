package com.example.demo.repository;

import com.example.demo.entity.Carga;
import com.example.demo.entity.Vehiculo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface CargaRepository extends JpaRepository<Carga, Integer> {

    List<Carga> findByVehiculo(Vehiculo vehiculo);

    List<Carga> findByFecha(LocalDate fecha);

    List<Carga> findByVehiculoAndFecha(Vehiculo vehiculo, LocalDate fecha);
}