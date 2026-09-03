package com.example.demo.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "ruta_zona")
public class RutaZona {

    @EmbeddedId
    private RutaZonaId id;

    @ManyToOne
    @MapsId("idRuta")
    @JoinColumn(name = "id_ruta", nullable = false)
    private Ruta ruta;

    @ManyToOne
    @MapsId("idZona")
    @JoinColumn(name = "id_zona", nullable = false)
    private Zona zona;

    @Column(name = "orden", nullable = false)
    private Integer orden;

    public RutaZona() {
    }

    public RutaZonaId getId() {
        return id;
    }

    public void setId(RutaZonaId id) {
        this.id = id;
    }

    public Ruta getRuta() {
        return ruta;
    }

    public void setRuta(Ruta ruta) {
        this.ruta = ruta;
    }

    public Zona getZona() {
        return zona;
    }

    public void setZona(Zona zona) {
        this.zona = zona;
    }

    public Integer getOrden() {
        return orden;
    }

    public void setOrden(Integer orden) {
        this.orden = orden;
    }
}