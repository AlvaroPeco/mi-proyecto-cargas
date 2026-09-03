package com.example.demo.entity;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class EstadoCargaConverter implements AttributeConverter<EstadoCarga, String> {

    @Override
    public String convertToDatabaseColumn(EstadoCarga estado) {
        if (estado == null) {
            return null;
        }

        return switch (estado) {
            case pendiente -> "pendiente";
            case en_preparacion -> "en preparacion";
            case cargada -> "cargada";
            case finalizada -> "finalizada";
        };
    }

    @Override
    public EstadoCarga convertToEntityAttribute(String valor) {
        if (valor == null) {
            return null;
        }

        return switch (valor) {
            case "pendiente" -> EstadoCarga.pendiente;
            case "en preparacion" -> EstadoCarga.en_preparacion;
            case "cargada" -> EstadoCarga.cargada;
            case "finalizada" -> EstadoCarga.finalizada;
            default -> throw new IllegalArgumentException(
                    "Estado de carga desconocido: " + valor
            );
        };
    }
}
