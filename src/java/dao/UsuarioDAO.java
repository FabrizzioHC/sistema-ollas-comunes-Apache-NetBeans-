/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import config.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import modelo.Usuario;
import modelo.OllaComun;
/**
 *
 * @author FABRIZZIO
 */
public class UsuarioDAO {
    
    private Conexion cn = new Conexion();
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    // 1. MÉTODO PARA INICIAR SESIÓN (LOGIN)
    public Usuario iniciarSesion(String email, String password) {
        Usuario usu = null; 
        String sql = "SELECT * FROM Usuario WHERE email = ? AND password_hash = ? AND activo = true";
        
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password); 
            rs = ps.executeQuery();
            
            if (rs.next()) {
                usu = new Usuario();
                usu.setId(rs.getInt("id"));
                usu.setEmail(rs.getString("email"));
                usu.setPasswordHash(rs.getString("password_hash"));
                usu.setNombres(rs.getString("nombres"));
                usu.setApellidos(rs.getString("apellidos"));
                usu.setRol(rs.getString("rol"));
                usu.setTelefono(rs.getString("telefono"));
                usu.setDni(rs.getString("dni"));
                usu.setActivo(rs.getBoolean("activo"));
                usu.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
            }
        } catch (SQLException e) {
            System.err.println("Error en iniciarSesion: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return usu;
    }

    // 2. REGISTRO DE DONADOR (USUARIOS NORMALES) -----> puede que aca tambien sea para el "Beneficiario"
    public boolean registrarUsuario(Usuario usu) {
        String sql = "INSERT INTO Usuario (email, password_hash, nombres, apellidos, rol, telefono, dni) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, usu.getEmail());
            ps.setString(2, usu.getPasswordHash());
            ps.setString(3, usu.getNombres());
            ps.setString(4, usu.getApellidos());
            ps.setString(5, usu.getRol());
            ps.setString(6, usu.getTelefono());
            ps.setString(7, usu.getDni());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error en registrarUsuario: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }

    // 3. REGISTRO OLLA COMUN CON SU LIDERESA
    public boolean registrarLideresaConOlla(Usuario usu, OllaComun olla) {
        String sqlUsuario = "INSERT INTO Usuario (email, password_hash, nombres, apellidos, rol, telefono, dni) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlOlla = "INSERT INTO Olla_Comun (usuario_id, nombre_olla, descripcion, direccion) VALUES (?, ?, ?, ?)";
        
        boolean exito = false;

        try {
            con = cn.getConnection();
            // Desactivamos el auto-commit para iniciar la transacción
            con.setAutoCommit(false); 
            
            // PASO 1: Insertar el Usuario y pedir que nos devuelva el ID que MySQL le asigne
            ps = con.prepareStatement(sqlUsuario, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, usu.getEmail());
            ps.setString(2, usu.getPasswordHash());
            ps.setString(3, usu.getNombres());
            ps.setString(4, usu.getApellidos());
            ps.setString(5, usu.getRol());
            ps.setString(6, usu.getTelefono());
            ps.setString(7, usu.getDni());
            ps.executeUpdate();
            
            // Capturamos el ID del usuario recién creado
            rs = ps.getGeneratedKeys();
            int idLideresaGenerado = 0;
            if (rs.next()) {
                idLideresaGenerado = rs.getInt(1);
            }
            
            // PASO 2: Insertar la Olla Común usando el ID de la lideresa
            ps = con.prepareStatement(sqlOlla);
            ps.setInt(1, idLideresaGenerado); // Conectamos la olla con su dueña
            ps.setString(2, olla.getNombreOlla());
            ps.setString(3, olla.getDescripcion());
            ps.setString(4, olla.getDireccion());
            ps.executeUpdate();
            
            // Si todo salió bien hasta aquí, guardamos permanentemente en la base de datos
            con.commit(); 
            exito = true;
            
        } catch (SQLException e) {
            System.err.println("Error en transacción de Lideresa: " + e.getMessage());
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                System.err.println("Error al hacer rollback: " + ex.getMessage());
            }
        } finally {
            try {
                if (con != null) con.setAutoCommit(true);
            } catch (SQLException e) {
                System.err.println("Error restaurando autoCommit: " + e.getMessage());
            }
            cerrarConexiones();
        }
        
        return exito;
    }
    
    // 4. ACTUALIZAR
    public boolean actualizarUsuario(Usuario usu) {
        // No actualizamos correo, contraseña ni rol por seguridad desde esta vista básica
        String sql = "UPDATE Usuario SET nombres = ?, apellidos = ?, telefono = ?, dni = ? WHERE id = ?";
        
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, usu.getNombres());
            ps.setString(2, usu.getApellidos());
            ps.setString(3, usu.getTelefono());
            ps.setString(4, usu.getDni());
            ps.setInt(5, usu.getId()); // Usamos el ID para saber a quién actualizar
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error en actualizarUsuario: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }
    
    // BUSCAR USUARIO POR ID
    public Usuario buscarPorId(int id) {

        Usuario usuario = null;

        String sql = "SELECT * FROM Usuario WHERE id = ?";

        try (Connection conexion = cn.getConnection();
             PreparedStatement sentencia = conexion.prepareStatement(sql)) {

            sentencia.setInt(1, id);

            try (ResultSet resultado = sentencia.executeQuery()) {

                if (resultado.next()) {

                    usuario = new Usuario();

                    usuario.setId(resultado.getInt("id"));
                    usuario.setNombres(resultado.getString("nombres"));
                    usuario.setApellidos(resultado.getString("apellidos"));
                    usuario.setEmail(resultado.getString("email"));
                    usuario.setDni(resultado.getString("dni"));
                    usuario.setTelefono(resultado.getString("telefono"));
                    usuario.setRol(resultado.getString("rol"));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar usuario: " + e.getMessage());
        }

        return usuario;
    }

    // LISTAR TODOS LOS USUARIOS (Para el panel de Admin)
    public List<modelo.Usuario> listarTodos() {
        List<modelo.Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM Usuario ORDER BY fecha_creacion DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                modelo.Usuario u = new modelo.Usuario();
                u.setId(rs.getInt("id"));
                u.setEmail(rs.getString("email"));
                u.setNombres(rs.getString("nombres"));
                u.setApellidos(rs.getString("apellidos"));
                u.setRol(rs.getString("rol"));
                u.setTelefono(rs.getString("telefono"));
                u.setDni(rs.getString("dni"));
                lista.add(u);
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodos: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }

    // ACTUALIZAR USUARIO DESDE ADMIN
    public boolean actualizarUsuarioAdmin(modelo.Usuario u) {
        String sql = "UPDATE Usuario SET nombres=?, apellidos=?, email=?, rol=?, telefono=?, dni=? WHERE id=?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, u.getNombres());
            ps.setString(2, u.getApellidos());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getRol());
            ps.setString(5, u.getTelefono());
            ps.setString(6, u.getDni());
            ps.setInt(7, u.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en actualizarUsuarioAdmin: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }
    
    // 11. ELIMINAR OLLA (ADMIN) ---- TEST
    public boolean eliminarUsuarioAdmin(int idUsu) {
        String sql = "DELETE FROM Usuario WHERE id=?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idUsu);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error eliminarUsuarioAdmin: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }
    
    // Método auxiliar para no repetir código de cierre
    private void cerrarConexiones() {
        try {
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(con != null) con.close();
        } catch (SQLException e) {
            System.err.println("Error cerrando conexiones: " + e);
        }
    }
}
