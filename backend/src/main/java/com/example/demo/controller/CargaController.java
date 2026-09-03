package com.example.demo.controller;

import com.example.demo.entity.Carga;
import com.example.demo.entity.Vehiculo;
import com.example.demo.service.CargaService;
import com.example.demo.service.VehiculoService;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/cargas")
@CrossOrigin(origins = "http://localhost:5173")
public class CargaController {

    private final CargaService cargaService;
    private final VehiculoService vehiculoService;

    public CargaController(
            CargaService cargaService,
            VehiculoService vehiculoService) {

        this.cargaService = cargaService;
        this.vehiculoService = vehiculoService;
    }

    @GetMapping
    public List<Carga> obtenerTodas() {
        return cargaService.obtenerTodas();
    }

    @GetMapping("/{id}")
    public Carga obtenerPorId(@PathVariable Integer id) {
        return cargaService.obtenerPorId(id);
    }

    @GetMapping("/vehiculo/{idVehiculo}")
    public List<Carga> obtenerPorVehiculo(
            @PathVariable Integer idVehiculo) {

        Vehiculo vehiculo = vehiculoService.obtenerPorId(idVehiculo);

        return cargaService.obtenerPorVehiculo(vehiculo);
    }

    @GetMapping("/fecha/{fecha}")
    public List<Carga> obtenerPorFecha(
            @PathVariable LocalDate fecha) {

        return cargaService.obtenerPorFecha(fecha);
    }

    @GetMapping("/vehiculo/{idVehiculo}/fecha/{fecha}")
    public List<Carga> obtenerPorVehiculoYFecha(
            @PathVariable Integer idVehiculo,
            @PathVariable LocalDate fecha) {

        Vehiculo vehiculo = vehiculoService.obtenerPorId(idVehiculo);

        return cargaService.obtenerPorVehiculoYFecha(
                vehiculo,
                fecha
        );
    }
}
