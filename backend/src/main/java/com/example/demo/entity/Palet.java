package com.example.demo.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "palets")
public class Palet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_palet")
    private Integer idPalet;

    @ManyToOne
    @JoinColumn(name = "id_carga", nullable = false)
    private Carga carga;

    @ManyToOne
    @JoinColumn(name = "id_cliente", nullable = false)
    private Cliente cliente;

    @ManyToOne
    @JoinColumn(name = "id_direccion", nullable = false)
    private DireccionEntrega direccion;

    @Column(name = "cod_escaneo", nullable = false, unique = true)
    private String codEscaneo;

    @Convert(converter = EstadoPaletConverter.class)
    @Column(name = "estado", nullable = false)
    private EstadoPalet estado = EstadoPalet.no_cargado;

    public Palet() {
    }

    public Integer getIdPalet() {
        return idPalet;
    }

    public void setIdPalet(Integer idPalet) {
        this.idPalet = idPalet;
    }

    public Carga getCarga() {
        return carga;
    }

    public void setCarga(Carga carga) {
        this.carga = carga;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public DireccionEntrega getDireccion() {
        return direccion;
    }

    public void setDireccion(DireccionEntrega direccion) {
        this.direccion = direccion;
    }

    public String getCodEscaneo() {
        return codEscaneo;
    }

    public void setCodEscaneo(String codEscaneo) {
        this.codEscaneo = codEscaneo;
    }

    public EstadoPalet getEstado() {
        return estado;
    }

    public void setEstado(EstadoPalet estado) {
        this.estado = estado;
    }
}