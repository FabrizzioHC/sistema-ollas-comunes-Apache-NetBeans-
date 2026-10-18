/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.sql.Timestamp;

/**
 *
 * @author FABRIZZIO
 */
public class Recurso {
    
    private int id;
    private int ollaId;
    private String nombreRecurso;
    private double cantidad;
    private String unidadMedida;
    private Timestamp fechaActualizacion;
    
    public Recurso (){
        
    }
    
    public Recurso(int id, int ollaId, String nombreRecurso, double cantidad, String unidadMedida, Timestamp fechaActualizacion) {
        this.id = id;
        this.ollaId = ollaId;
        this.nombreRecurso = nombreRecurso;
        this.cantidad = cantidad;
        this.unidadMedida = unidadMedida;
        this.fechaActualizacion = fechaActualizacion;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOllaId() {
        return ollaId;
    }

    public void setOllaId(int ollaId) {
        this.ollaId = ollaId;
    }

    public String getNombreRecurso() {
        return nombreRecurso;
    }

    public void setNombreRecurso(String nombreRecurso) {
        this.nombreRecurso = nombreRecurso;
    }

    public double getCantidad() {
        return cantidad;
    }

    public void setCantidad(double cantidad) {
        this.cantidad = cantidad;
    }

    public String getUnidadMedida() {
        return unidadMedida;
    }

    public void setUnidadMedida(String unidadMedida) {
        this.unidadMedida = unidadMedida;
    }

    public Timestamp getFechaActualizacion() {
        return fechaActualizacion;
    }

    public void setFechaActualizacion(Timestamp fechaActualizacion) {
        this.fechaActualizacion = fechaActualizacion;
    }
}
