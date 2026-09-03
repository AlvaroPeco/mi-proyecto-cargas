package com.example.demo.entity;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class EstadoPaletConverter implements AttributeConverter<EstadoPalet, String> {

    @Override
    public String convertToDatabaseColumn(EstadoPalet estado) {
        if (estado == null) {
            return null;
        }

        return switch (estado) {
            case cargado -> "cargado";
            case no_cargado -> "no cargado";
        };
    }

    @Override
    public EstadoPalet convertToEntityAttribute(String valor) {
        if (valor == null) {
            return null;
        }

        return switch (valor) {
            case "cargado" -> EstadoPalet.cargado;
            case "no cargado" -> EstadoPalet.no_cargado;
            default -> throw new IllegalArgumentException(
                    "Estado de palé desconocido: " + valor
            );
        };
    }
}
