package com.example.demo.controller;

import com.example.demo.entity.LogMovimiento;
import com.example.demo.entity.Usuario;
import com.example.demo.repository.LogMovimientoRepository;
import com.example.demo.repository.UsuarioRepository;
import jakarta.servlet.http.HttpServletRequest; // <-- Importante
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(origins = {"http://localhost:5173", "http://192.168.1.42:5173"}, allowCredentials = "true")
public class UsuarioController {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final LogMovimientoRepository logMovimientoRepository;

    public UsuarioController(UsuarioRepository usuarioRepository, 
                             PasswordEncoder passwordEncoder, 
                             LogMovimientoRepository logMovimientoRepository) {
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.logMovimientoRepository = logMovimientoRepository;
    }

    // Método auxiliar para obtener la IP del cliente
    private String obtenerIpCliente(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        } else {
            // Si hay múltiples proxies, tomamos la primera IP
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials, HttpServletRequest request) {
        String nombreUsuario = credentials.get("nombre");
        String password = credentials.get("password");
        String clientIp = obtenerIpCliente(request);

        Optional<Usuario> usuarioOpt = usuarioRepository.findByNombre(nombreUsuario);

        if (usuarioOpt.isPresent()) {
            Usuario usuario = usuarioOpt.get();
            if (passwordEncoder.matches(password, usuario.getPassword())) {
                
                // Registramos log SIN palet (null) e incluyendo la IP
                LogMovimiento logExito = new LogMovimiento(
                    null, 
                    usuario, 
                    "LOGIN_EXITOSO [IP: " + clientIp + "]", 
                    LocalDateTime.now()
                );
                logMovimientoRepository.save(logExito);

                return ResponseEntity.ok(usuario);
            } else {
                
                LogMovimiento logFallido = new LogMovimiento(
                    null, 
                    usuario, 
                    "LOGIN_FALLIDO (Contraseña incorrecta) [IP: " + clientIp + "]", 
                    LocalDateTime.now()
                );
                logMovimientoRepository.save(logFallido);
            }
        }

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Credenciales incorrectas");
    }

    @PostMapping("/registro")
    public ResponseEntity<?> registrar(@RequestBody Usuario usuario, 
                                       @RequestParam(required = false) Long idAdmin, 
                                       HttpServletRequest request) {
                                       
        String clientIp = obtenerIpCliente(request);

        usuario.setPassword(passwordEncoder.encode(usuario.getPassword()));
        Usuario nuevoUsuario = usuarioRepository.save(usuario);

        Usuario creador = (idAdmin != null) 
            ? usuarioRepository.findById(idAdmin).orElse(nuevoUsuario) 
            : nuevoUsuario;

        // Registramos log SIN palet (null) e incluyendo la IP
        LogMovimiento logRegistro = new LogMovimiento(
            null, 
            creador, 
            "CREAR_USUARIO (" + nuevoUsuario.getNombre() + ") [IP: " + clientIp + "]", 
            LocalDateTime.now()
        );
        logMovimientoRepository.save(logRegistro);

        return ResponseEntity.ok(nuevoUsuario);
    }
}