package com.example.demo.controller;

import com.example.demo.entity.LogMovimiento;
import com.example.demo.entity.Usuario;
import com.example.demo.repository.LogMovimientoRepository;
import com.example.demo.repository.UsuarioRepository;
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
    private final LogMovimientoRepository logMovimientoRepository; // 1. Inyectamos el repositorio de logs

    public UsuarioController(UsuarioRepository usuarioRepository, 
                             PasswordEncoder passwordEncoder, 
                             LogMovimientoRepository logMovimientoRepository) {
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.logMovimientoRepository = logMovimientoRepository;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String nombreUsuario = credentials.get("nombre");
        String password = credentials.get("password");

        System.out.println("-> HASH DE PRUEBA para '12345678': " + passwordEncoder.encode("12345678"));
        System.out.println("-> Intentando login con usuario: '" + nombreUsuario + "' y password: '" + password + "'");

        Optional<Usuario> usuarioOpt = usuarioRepository.findByNombre(nombreUsuario);

        if (usuarioOpt.isPresent()) {
            Usuario usuario = usuarioOpt.get();
            System.out.println("-> Usuario encontrado en BD: " + usuario.getNombre());
            System.out.println("-> Password (hash) guardado en BD: " + usuario.getPassword());

            boolean passwordCoincide = passwordEncoder.matches(password, usuario.getPassword());
            System.out.println("-> ¿Coincide la contraseña?: " + passwordCoincide);

            if (passwordCoincide) {
                // 2. REGISTRAR LOGIN EXITOSO
                LogMovimiento logExito = new LogMovimiento(null, usuario, "LOGIN_EXITOSO", LocalDateTime.now());
                logMovimientoRepository.save(logExito);

                return ResponseEntity.ok(usuario);
            } else {
                System.out.println("-> FALLO: El password Encoder dice que NO coinciden.");

                // 3. REGISTRAR INTENTO FALLIDO (Contraseña incorrecta)
                LogMovimiento logFallido = new LogMovimiento(null, usuario, "LOGIN_FALLIDO (Contraseña incorrecta)", LocalDateTime.now());
                logMovimientoRepository.save(logFallido);
            }
        } else {
            System.out.println("-> FALLO: No se encuentra el usuario en la BD.");
            // Si el usuario ni siquiera existe, no se puede asociar a la BD si el objeto Usuario es obligatorio.
        }

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Credenciales incorrectas");
    }

    // Endpoint para registrar nuevos usuarios con contraseña cifrada
    @PostMapping("/registro")
    public ResponseEntity<?> registrar(@RequestBody Usuario usuario, @RequestParam(required = false) Long idAdmin) {
        // Cifrar la contraseña antes de guardar en la base de datos
        usuario.setPassword(passwordEncoder.encode(usuario.getPassword()));
        Usuario nuevoUsuario = usuarioRepository.save(usuario);

        // 4. REGISTRAR ALTA DE USUARIO
        // Buscamos quién fue el admin que lo creó (si se envía idAdmin), de lo contrario usa al mismo usuario creado
        Usuario creador = (idAdmin != null) 
            ? usuarioRepository.findById(idAdmin).orElse(nuevoUsuario) 
            : nuevoUsuario;

        LogMovimiento logRegistro = new LogMovimiento(
            null, 
            creador, 
            "CREAR_USUARIO (" + nuevoUsuario.getNombre() + ")", 
            LocalDateTime.now()
        );
        logMovimientoRepository.save(logRegistro);

        return ResponseEntity.ok(nuevoUsuario);
    }
}