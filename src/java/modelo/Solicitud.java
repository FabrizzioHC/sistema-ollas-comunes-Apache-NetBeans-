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
public class Solicitud {
    
    private int id;
    private int ollaId;
    private String nombreOlla;
    private String recursoNecesitado;
    private double cantidadNecesitada;
    private String unidadMedida;
    private String nivelUrgencia;
    private String estado;
    private Timestamp fechaSolicitud; // para el DATE de base de datos

    // Constructor vacío
    public Solicitud() {
        
    }

    // Constructor completo
    public Solicitud(int id, int ollaId, String nombreOlla, String recursoNecesitado, double cantidadNecesitada, String unidadMedida, String nivelUrgencia, String estado, Timestamp fechaSolicitud) {
        this.id = id;
        this.ollaId = ollaId;
        this.nombreOlla = nombreOlla;
        this.recursoNecesitado = recursoNecesitado;
        this.cantidadNecesitada = cantidadNecesitada;
        this.unidadMedida = unidadMedida;
        this.nivelUrgencia = nivelUrgencia;
        this.estado = estado;
        this.fechaSolicitud = fechaSolicitud;
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

    public String getNombreOlla() {
        return nombreOlla;
    }

    public void setNombreOlla(String nombreOlla) {
        this.nombreOlla = nombreOlla;
    }
    
    public String getRecursoNecesitado() {
        return recursoNecesitado;
    }

    public void setRecursoNecesitado(String recursoNecesitado) {
        this.recursoNecesitado = recursoNecesitado;
    }

    public double getCantidadNecesitada() {
        return cantidadNecesitada;
    }

    public void setCantidadNecesitada(double cantidadNecesitada) {
        this.cantidadNecesitada = cantidadNecesitada;
    }

    public String getUnidadMedida() {
        return unidadMedida;
    }

    public void setUnidadMedida(String unidadMedida) {
        this.unidadMedida = unidadMedida;
    }

    public String getNivelUrgencia() {
        return nivelUrgencia;
    }

    public void setNivelUrgencia(String nivelUrgencia) {
        this.nivelUrgencia = nivelUrgencia;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Timestamp getFechaSolicitud() {
        return fechaSolicitud;
    }

    public void setFechaSolicitud(Timestamp fechaSolicitud) {
        this.fechaSolicitud = fechaSolicitud;
    }
}
