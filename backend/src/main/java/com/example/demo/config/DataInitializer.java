package com.example.demo.config; // (o el paquete donde tengas tus configuraciones)

import com.example.demo.entity.Usuario;
import com.example.demo.repository.UsuarioRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner initDatabase(UsuarioRepository usuarioRepository, PasswordEncoder passwordEncoder) {
        return args -> {
            if (usuarioRepository.findByNombre("admin").isEmpty()) {
                Usuario admin = new Usuario();
                admin.setNombre("admin");
                admin.setEmail("admin@empresa.com");
                admin.setPassword(passwordEncoder.encode("12345678"));
                admin.setRol("ADMIN");
                
                usuarioRepository.save(admin);
                System.out.println("-> Usuario admin creado automáticamente al arrancar.");
            }
        };
    }
}