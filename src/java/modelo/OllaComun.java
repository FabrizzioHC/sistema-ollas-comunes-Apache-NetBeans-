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
public class OllaComun {
    
    private int id;
    private int usuario_Id; // Aquí guardamos el ID de la Lideresa a cargo (Llave foránea)
    private String nombre_Olla;
    private String descripcion;
    private String direccion;
    private int beneficiariosAtendidos;
    private String estado;
    private Timestamp fecha_Creacion;

    public OllaComun() {
        
    }

    public OllaComun (int id, int usuario_Id, String nombre_Olla, String descripcion, String direccion, int beneficiariosAtendidos, String estado, Timestamp fecha_Creacion) {
        this.id = id;
        this.usuario_Id = usuario_Id;
        this.nombre_Olla = nombre_Olla;
        this.descripcion = descripcion;
        this.direccion = direccion;
        this.beneficiariosAtendidos = beneficiariosAtendidos;
        this.estado = estado;
        this.fecha_Creacion = fecha_Creacion;
    }

    public int getId () { 
        return id; 
    }
    
    public void setId (int id) { 
        this.id = id; 
    }

    public int getUsuarioId () { 
        return usuario_Id; 
    }
    
    public void setUsuarioId (int usuario_Id) { 
        this.usuario_Id = usuario_Id; 
    }

    public String getNombreOlla () { 
        return nombre_Olla; 
    }
    
    public void setNombreOlla (String nombre_Olla) { 
        this.nombre_Olla = nombre_Olla; 
    }

    public String getDescripcion () { 
        return descripcion; 
    }
    
    public void setDescripcion (String descripcion) { 
        this.descripcion = descripcion;
    }

    public String getDireccion () { 
        return direccion; 
    }
    
    public void setDireccion (String direccion) { 
        this.direccion = direccion; 
    }

    public int getBeneficiariosAtendidos () { 
        return beneficiariosAtendidos; 
    }
    
    public void setBeneficiariosAtendidos (int beneficiariosAtendidos) { 
        this.beneficiariosAtendidos = beneficiariosAtendidos; 
    }

    public String getEstado () { 
        return estado; 
    }
    
    public void setEstado (String estado) { 
        this.estado = estado; 
    }

    public Timestamp getFechaCreacion () { 
        return fecha_Creacion; 
    }
    
    public void setFechaCreacion (Timestamp fecha_Creacion) { 
        this.fecha_Creacion = fecha_Creacion; 
    }
}
