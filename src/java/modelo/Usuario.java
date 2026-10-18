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
public class Usuario {
    
    private int id;
    private String email;
    private String password_Hash;
    private String nombres;
    private String apellidos;
    private String rol;
    private String telefono;
    private String dni;
    private boolean activo;
    private Timestamp fecha_Creacion; // captura la fecha y hora exacta ademas tambien lo usa la base de datos
   
    public Usuario() {
        
    }

    public Usuario(int id, String email, String password_Hash, String nombres, String apellidos, String rol, String telefono, String dni, boolean activo, Timestamp fecha_Creacion) {
        this.id = id;
        this.email = email;
        this.password_Hash = password_Hash;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.rol = rol;
        this.telefono = telefono;
        this.dni = dni;
        this.activo = activo;
        this.fecha_Creacion = fecha_Creacion;
    }

    public int getId () { 
        return id; 
    }
    
    public void setId (int id) { 
        this.id = id; 
    }

    public String getEmail () { 
        return email; 
    }
    
    public void setEmail (String email) { 
        this.email = email; 
    }

    public String getPasswordHash () { 
        return password_Hash; 
    }
    
    public void setPasswordHash (String password_Hash) { 
        this.password_Hash = password_Hash; 
    }

    public String getNombres () { 
        return nombres; 
    }
    
    public void setNombres (String nombres) { 
        this.nombres = nombres; 
    }

    public String getApellidos () { 
        return apellidos; 
    }
    
    public void setApellidos (String apellidos) { 
        this.apellidos = apellidos; 
    }

    public String getRol () { 
        return rol; 
    }
    
    public void setRol (String rol) { 
        this.rol = rol; 
    }

    public String getTelefono () { 
        return telefono; 
    }
    
    public void setTelefono (String telefono) { 
        this.telefono = telefono; 
    }

    public String getDni () { 
        return dni; 
    }
    public void setDni (String dni) { 
        this.dni = dni; 
    }

    public boolean isActivo () { 
        return activo; 
    }
    
    public void setActivo (boolean activo) { 
        this.activo = activo; 
    }

    public Timestamp getFechaCreacion () { 
        return fecha_Creacion;
    }
    
    public void setFechaCreacion (Timestamp fecha_Creacion) { 
        this.fecha_Creacion = fecha_Creacion; 
    }
}
