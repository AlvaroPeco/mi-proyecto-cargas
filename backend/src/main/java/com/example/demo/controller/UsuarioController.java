package com.example.demo.controller;

import com.example.demo.entity.Usuario;
import com.example.demo.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(origins = {"http://localhost:5173", "http://192.168.1.42:5173"}, allowCredentials = "true")
public class UsuarioController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        // Corregido para leer la clave "nombre" que envía el frontend
        String nombreUsuario = credentials.get("nombre");
        String password = credentials.get("password");

        // Línea de prueba para ver el hash generado en caliente por Spring
        System.out.println("-> HASH DE PRUEBA para '12345678': " + passwordEncoder.encode("12345678"));
        System.out.println("-> Intentando login con usuario: '" + nombreUsuario + "' y password: '" + password + "'");

        // 1. Buscar usuario por su nombre
        Optional<Usuario> usuarioOpt = usuarioRepository.findByNombre(nombreUsuario);

        if (usuarioOpt.isPresent()) {
            Usuario usuario = usuarioOpt.get();
            System.out.println("-> Usuario encontrado en BD: " + usuario.getNombre());
            System.out.println("-> Password (hash) guardado en BD: " + usuario.getPassword());

            // 2. Verificar la contraseña en texto plano contra el hash cifrado
            boolean passwordCoincide = passwordEncoder.matches(password, usuario.getPassword());
            System.out.println("-> ¿Coincide la contraseña?: " + passwordCoincide);

            if (passwordCoincide) {
                return ResponseEntity.ok(usuario);
            } else {
                System.out.println("-> FALLO: El password Encoder dice que NO coinciden.");
            }
        } else {
            System.out.println("-> FALLO: No se encuentra el usuario en la BD.");
        }

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Credenciales incorrectas");
    }
    //gg
    // Endpoint para registrar nuevos usuarios con contraseña cifrada
    @PostMapping("/registro")
    public ResponseEntity<?> registrar(@RequestBody Usuario usuario) {
        // Cifrar la contraseña antes de guardar en la base de datos
        usuario.setPassword(passwordEncoder.encode(usuario.getPassword()));
        Usuario nuevoUsuario = usuarioRepository.save(usuario);
        return ResponseEntity.ok(nuevoUsuario);
    }
}