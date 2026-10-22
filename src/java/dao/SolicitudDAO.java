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
import java.util.ArrayList;
import java.util.List;
import modelo.Solicitud;
/**
 *
 * @author FABRIZZIO
 */
public class SolicitudDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // 1. LEER  Listar solicitudes por el ID de la Olla (Para la Lideresa)
    public List<Solicitud> listarPorOlla(int idOlla) {
        List<Solicitud> lista = new ArrayList<>();
        String sql = "SELECT * FROM Solicitud WHERE olla_id = ? ORDER BY fecha_solicitud DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idOlla);
            rs = ps.executeQuery();
            while (rs.next()) {
                Solicitud s = new Solicitud();
                s.setId(rs.getInt("id"));
                s.setOllaId(rs.getInt("olla_id"));
                s.setRecursoNecesitado(rs.getString("recurso_necesitado"));
                s.setCantidadNecesitada(rs.getDouble("cantidad_necesitada"));
                s.setUnidadMedida(rs.getString("unidad_medida"));
                s.setNivelUrgencia(rs.getString("nivel_urgencia"));
                s.setEstado(rs.getString("estado"));
                s.setFechaSolicitud(rs.getTimestamp("fecha_solicitud"));
                lista.add(s);
            }
        } catch (SQLException e) {
            System.err.println("Error en listarPorOlla: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }

    // 2. CREAR Registrar una nueva solicitud en la base de datos
    public boolean crearSolicitud(Solicitud s) {
        String sql = "INSERT INTO Solicitud (olla_id, recurso_necesitado, cantidad_necesitada, unidad_medida, nivel_urgencia, estado) VALUES (?, ?, ?, ?, ?, 'Pendiente')";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, s.getOllaId());
            ps.setString(2, s.getRecursoNecesitado());
            ps.setDouble(3, s.getCantidadNecesitada());
            ps.setString(4, s.getUnidadMedida());
            ps.setString(5, s.getNivelUrgencia());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en crearSolicitud: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }

    // 3. ACTUALIZAR  Modificar una solicitud existente desde el Modal
    public boolean actualizarSolicitud(Solicitud s) {
        String sql = "UPDATE Solicitud SET recurso_necesitado=?, cantidad_necesitada=?, unidad_medida=?, nivel_urgencia=? WHERE id=?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, s.getRecursoNecesitado());
            ps.setDouble(2, s.getCantidadNecesitada());
            ps.setString(3, s.getUnidadMedida());
            ps.setString(4, s.getNivelUrgencia());
            ps.setInt(5, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en actualizarSolicitud: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }

    // 4. ELIMINAR  Borrar una solicitud
    public boolean eliminarSolicitud(int idSolicitud) {
        String sql = "DELETE FROM Solicitud WHERE id=?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idSolicitud);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en eliminarSolicitud: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }
    
    // 5. LISTAR TODAS LAS SOLICITUDES PARA EL ADMINISTRADOR (Con el nombre de la olla)
    public List<Solicitud> listarTodasLasSolicitudes() {
        List<Solicitud> lista = new ArrayList<>();
        String sql = "SELECT s.*, o.nombre_olla FROM Solicitud s INNER JOIN Olla_Comun o ON s.olla_id = o.id ORDER BY s.fecha_solicitud DESC";
        
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Solicitud s = new Solicitud();
                s.setId(rs.getInt("id"));
                s.setOllaId(rs.getInt("olla_id"));
                s.setRecursoNecesitado(rs.getString("recurso_necesitado"));
                s.setCantidadNecesitada(rs.getDouble("cantidad_necesitada"));
                s.setUnidadMedida(rs.getString("unidad_medida"));
                s.setNivelUrgencia(rs.getString("nivel_urgencia"));
                s.setEstado(rs.getString("estado"));
                s.setFechaSolicitud(rs.getTimestamp("fecha_solicitud"));
                
                // Asegúrate de tener el atributo 'nombreOlla' en tu clase modelo.Solicitud
                s.setNombreOlla(rs.getString("nombre_olla")); 
                lista.add(s);
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodasLasSolicitudes: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }

    // 6. CAMBIAR EL ESTADO DE UNA SOLICITUD (Aceptar o Rechazar por el Admin)
    public boolean cambiarEstadoSolicitud(int idSolicitud, String nuevoEstado) {
        String sql = "UPDATE Solicitud SET estado = ? WHERE id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idSolicitud);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en cambiarEstadoSolicitud: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }

    // Método auxiliar para evitar memory leaks y bloquear la base de datos
    private void cerrarConexiones() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            System.err.println("Error al cerrar conexiones: " + e.getMessage());
        }
    }
}
