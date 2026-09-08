package com.example.demo.controller;

import com.example.demo.entity.Carga;
import com.example.demo.entity.Palet;
import com.example.demo.service.CargaService;
import com.example.demo.service.PaletService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/palets")
@CrossOrigin(origins = {"http://localhost:5173", "http://192.168.1.42:5173"}, allowCredentials = "true")
public class PaletController {

    private final PaletService paletService;
    private final CargaService cargaService;

    public PaletController(
            PaletService paletService,
            CargaService cargaService) {

        this.paletService = paletService;
        this.cargaService = cargaService;
    }

    @GetMapping
    public List<Palet> obtenerTodos() {
        return paletService.obtenerTodos();
    }

    @GetMapping("/{id}")
    public Palet obtenerPorId(@PathVariable Integer id) {
        return paletService.obtenerPorId(id);
    }

    @GetMapping("/carga/{idCarga}")
    public List<Palet> obtenerPorCarga(
            @PathVariable Integer idCarga) {

        Carga carga = cargaService.obtenerPorId(idCarga);

        return paletService.obtenerPorCarga(carga);
    }

    @GetMapping("/escaneo/{codEscaneo}")
    public Palet obtenerPorCodigoEscaneo(
            @PathVariable String codEscaneo) {

        return paletService.obtenerPorCodigoEscaneo(codEscaneo);
    }

    @PostMapping("/escanear/{codEscaneo}")
    public Palet escanearPalet(
            @PathVariable String codEscaneo,
            @RequestBody(required = false) Map<String, Long> payload) {

        Long idUsuario = null;
        if (payload != null && payload.containsKey("idUsuario")) {
            idUsuario = payload.get("idUsuario");
        }

        return paletService.escanearPalet(codEscaneo, idUsuario);
    }
}