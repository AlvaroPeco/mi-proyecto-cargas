package com.example.demo.config; // Ajusta el paquete según dónde lo guardes

import com.example.demo.service.CargaService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SincronizadorStartup {

    @Bean
    CommandLineRunner ejecutarSincronizacionAlArrancar(CargaService cargaService) {
        return args -> {
            cargaService.sincronizarEstadosDeCargas();
            System.out.println(">>> [INICIO] Estados de las cargas sincronizados y actualizados en la BD.");
        };
    }
}