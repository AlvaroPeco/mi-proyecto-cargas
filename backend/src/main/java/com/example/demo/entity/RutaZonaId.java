package com.example.demo.entity;

import jakarta.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class RutaZonaId implements Serializable {

    private Integer idRuta;
    private Integer idZona;

    public RutaZonaId() {
    }

    public RutaZonaId(Integer idRuta, Integer idZona) {
        this.idRuta = idRuta;
        this.idZona = idZona;
    }

    public Integer getIdRuta() {
        return idRuta;
    }

    public void setIdRuta(Integer idRuta) {
        this.idRuta = idRuta;
    }

    public Integer getIdZona() {
        return idZona;
    }

    public void setIdZona(Integer idZona) {
        this.idZona = idZona;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof RutaZonaId)) return false;
        RutaZonaId that = (RutaZonaId) o;
        return Objects.equals(idRuta, that.idRuta)
                && Objects.equals(idZona, that.idZona);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idRuta, idZona);
    }
}
