/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 *
 * @author FABRIZZIO
 */
public class Donacion {
 
    private int id;
    private int donadorId;
    private int ollaId;
    private String mensaje;
    private String estado;
    private Timestamp fechaRegistro;

    public Donacion (){
        
    }

    public Donacion(int id, int donadorId, int ollaId, String mensaje, String estado, Timestamp fechaRegistro) {
        this.id = id;
        this.donadorId = donadorId;
        this.ollaId = ollaId;
        this.mensaje = mensaje;
        this.estado = estado;
        this.fechaRegistro = fechaRegistro;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getDonadorId() {
        return donadorId;
    }

    public void setDonadorId(int donadorId) {
        this.donadorId = donadorId;
    }

    public int getOllaId() {
        return ollaId;
    }

    public void setOllaId(int ollaId) {
        this.ollaId = ollaId;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
}
