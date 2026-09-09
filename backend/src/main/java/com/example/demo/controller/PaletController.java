package com.example.demo.controller;

import com.example.demo.entity.Carga;
import com.example.demo.entity.LogMovimiento;
import com.example.demo.entity.Palet;
import com.example.demo.entity.Usuario;
import com.example.demo.repository.LogMovimientoRepository;
import com.example.demo.repository.UsuarioRepository;
import com.example.demo.service.CargaService;
import com.example.demo.service.PaletService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/palets")
@CrossOrigin(origins = {"http://localhost:5173", "http://192.168.1.42:5173"}, allowCredentials = "true")
public class PaletController {

    private final PaletService paletService;
    private final CargaService cargaService;
    private final LogMovimientoRepository logMovimientoRepository; // 1. Repositorio de logs
    private final UsuarioRepository usuarioRepository;            // 2. Repositorio de usuarios

    public PaletController(
            PaletService paletService,
            CargaService cargaService,
            LogMovimientoRepository logMovimientoRepository,
            UsuarioRepository usuarioRepository) {

        this.paletService = paletService;
        this.cargaService = cargaService;
        this.logMovimientoRepository = logMovimientoRepository;
        this.usuarioRepository = usuarioRepository;
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
    public List<Palet> obtenerPorCarga(@PathVariable Integer idCarga) {
        Carga carga = cargaService.obtenerPorId(idCarga);
        return paletService.obtenerPorCarga(carga);
    }

    @GetMapping("/escaneo/{codEscaneo}")
    public Palet obtenerPorCodigoEscaneo(@PathVariable String codEscaneo) {
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

        Palet paletEscaneado = paletService.escanearPalet(codEscaneo, idUsuario);

        // REGISTRAR LOG DE ESCANEO
        if (idUsuario != null && paletEscaneado != null) {
            Usuario usuario = usuarioRepository.findById(idUsuario).orElse(null);
            if (usuario != null) {
                LogMovimiento log = new LogMovimiento(paletEscaneado, usuario, "ESCANEAR_PALET", LocalDateTime.now());
                logMovimientoRepository.save(log);
            }
        }

        return paletEscaneado;
    }

    @PutMapping("/{id}/marcar-cargado")
    public Palet marcarComoCargado(
            @PathVariable Integer id,
            @RequestParam(required = false) Long idUsuario) {

        Palet paletModificado = paletService.marcarComoCargado(id);

        // REGISTRAR LOG DE MARCAR CARGADO
        if (idUsuario != null && paletModificado != null) {
            Usuario usuario = usuarioRepository.findById(idUsuario).orElse(null);
            if (usuario != null) {
                LogMovimiento log = new LogMovimiento(paletModificado, usuario, "MARCAR_CARGADO", LocalDateTime.now());
                logMovimientoRepository.save(log);
            }
        }

        return paletModificado;
    }

    @PutMapping("/{id}/desmarcar-cargado")
    public ResponseEntity<Palet> desmarcarComoCargado(
            @PathVariable Integer id,
            @RequestParam(required = false) Long idUsuario) {

        Palet paletActualizado = paletService.desmarcarComoCargado(id);

        // REGISTRAR LOG DE DESMARCAR CARGADO
        if (idUsuario != null && paletActualizado != null) {
            Usuario usuario = usuarioRepository.findById(idUsuario).orElse(null);
            if (usuario != null) {
                LogMovimiento log = new LogMovimiento(paletActualizado, usuario, "DESMARCAR_CARGADO", LocalDateTime.now());
                logMovimientoRepository.save(log);
            }
        }

        return ResponseEntity.ok(paletActualizado);
    }
}