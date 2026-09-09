package com.example.demo.controller;

import com.example.demo.entity.LogMovimiento;
import com.example.demo.entity.Usuario;
import com.example.demo.repository.LogMovimientoRepository;
import com.example.demo.repository.UsuarioRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/logs")
@CrossOrigin(origins = {"http://localhost:5173", "http://192.168.1.42:5173"}, allowCredentials = "true")
public class LogMovimientoController {

    private final LogMovimientoRepository logMovimientoRepository;
    private final UsuarioRepository usuarioRepository;

    // Constructor para inyectar las dependencias (elimina los avisos de @Autowired)
    public LogMovimientoController(LogMovimientoRepository logMovimientoRepository, UsuarioRepository usuarioRepository) {
        this.logMovimientoRepository = logMovimientoRepository;
        this.usuarioRepository = usuarioRepository;
    }

    @GetMapping
    public ResponseEntity<?> obtenerTodosLosLogs(@RequestParam Long idUsuario) {
        Usuario usuario = usuarioRepository.findById(idUsuario).orElse(null);

        if (usuario == null || !"ADMIN".equalsIgnoreCase(usuario.getRol())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Acceso denegado: Se requieren permisos de Administrador.");
        }

        List<LogMovimiento> logs = logMovimientoRepository.findAllByOrderByFechaHoraDesc();
        return ResponseEntity.ok(logs);
    }

    @DeleteMapping("/limpiar")
    public ResponseEntity<?> limpiarLogs(@RequestParam Long idUsuario) {
        Usuario usuario = usuarioRepository.findById(idUsuario).orElse(null);

        if (usuario == null || !"ADMIN".equalsIgnoreCase(usuario.getRol())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Acceso denegado.");
        }

        logMovimientoRepository.deleteAll();
            return ResponseEntity.ok("Historial de logs limpiado correctamente.");
    }
}