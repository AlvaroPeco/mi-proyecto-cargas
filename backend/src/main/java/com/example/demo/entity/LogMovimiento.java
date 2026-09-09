package com.example.demo.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "log_movimientos")
public class LogMovimiento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = true)
    @JoinColumn(name = "id_palet", nullable = true)
    private Palet palet;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @Column(nullable = false, length = 100)
    private String accion;

    @Column(name = "fecha_hora", nullable = false)
    private LocalDateTime fechaHora;

    public LogMovimiento() {}

    public LogMovimiento(Palet palet, Usuario usuario, String accion, LocalDateTime fechaHora) {
        this.palet = palet;
        this.usuario = usuario;
        this.accion = accion;
        this.fechaHora = fechaHora;
    }

    // Getters y Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Palet getPalet() { return palet; }
    public void setPalet(Palet palet) { this.palet = palet; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public String getAccion() { return accion; }
    public void setAccion(String accion) { this.accion = accion; }

    public LocalDateTime getFechaHora() { return fechaHora; }
    public void setFechaHora(LocalDateTime fechaHora) { this.fechaHora = fechaHora; }
}
