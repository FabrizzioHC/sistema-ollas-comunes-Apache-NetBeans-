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
import modelo.Donacion;
import modelo.OllaComun;

/**
 *
 * @author FABRIZZIO
 */
public class DonacionDAO {
    private Conexion cn = new Conexion();
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    // 1. REGISTRAR DONACIÓN
    public boolean registrarDonacion(Donacion d) {
        String sql = "INSERT INTO Donacion (donador_id, olla_id, mensaje, estado) VALUES (?, ?, ?, 'Pendiente')";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, d.getDonadorId());
            ps.setInt(2, d.getOllaId());
            ps.setString(3, d.getMensaje());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en registrarDonacion: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }

    // 2. LISTAR DONACIONES DE UN USUARIO (CON EL NOMBRE DE LA OLLA)
    // Nota: Como Donacion no tiene "nombreOlla", usaremos el campo "mensaje" u otro truco, 
    // pero lo ideal es crear un DTO o simplemente concatenarlo. 
    // Para simplificar, devolveremos una lista de arreglos de Objetos o ajustamos el modelo.
    // Vamos a usar el modelo Donacion y le seteamos el estado temporalmente modificado o creamos el join.
    public List<String[]> listarMisDonaciones(int idDonador) {
        List<String[]> lista = new ArrayList<>();
        String sql = "SELECT d.fecha_registro, o.nombre_olla, d.mensaje, d.estado " +
                     "FROM Donacion d INNER JOIN Olla_Comun o ON d.olla_id = o.id " +
                     "WHERE d.donador_id = ? ORDER BY d.fecha_registro DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idDonador);
            rs = ps.executeQuery();
            while (rs.next()) {
                String[] fila = new String[4];
                fila[0] = rs.getString("fecha_registro");
                fila[1] = rs.getString("nombre_olla");
                fila[2] = rs.getString("mensaje");
                fila[3] = rs.getString("estado");
                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("Error listarMisDonaciones: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }

    // 3. LISTAR TODAS LAS OLLAS COMUNES (Para llenar el <select> del formulario)
    public List<OllaComun> listarTodasOllas() {
        List<OllaComun> lista = new ArrayList<>();
        String sql = "SELECT * FROM Olla_Comun";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                OllaComun o = new OllaComun();
                o.setId(rs.getInt("id"));
                o.setNombreOlla(rs.getString("nombre_olla"));
                lista.add(o);
            }
        } catch (SQLException e) {
            System.err.println("Error listarTodasOllas: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }
    
    // 4. LISTAR DONACIONES GLOBALES APROBADAS (Para la vista pública)
    public List<String[]> listarDonacionesAprobadasGlobales() {
        List<String[]> lista = new ArrayList<>();

        String sql = "SELECT d.fecha_registro, u.nombres, o.nombre_olla, d.mensaje " +
                     "FROM Donacion d " +
                     "INNER JOIN Olla_Comun o ON d.olla_id = o.id " +
                     "INNER JOIN Usuario u ON d.donador_id = u.id " +
                     "WHERE d.estado = 'Aceptada' ORDER BY d.fecha_registro DESC LIMIT 15";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                String[] fila = new String[4];
                fila[0] = rs.getString("fecha_registro");
                fila[1] = rs.getString("nombres");      // Quién donó
                fila[2] = rs.getString("nombre_olla");  // A qué olla
                fila[3] = rs.getString("mensaje");      // Qué donó
                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("Error listarDonacionesGlobales: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }
    
    // 5. LISTAR TODAS LAS DONACIONES (admin)
    public List<String[]> listarTodasLasDonacionesAdmin() {
        List<String[]> lista = new ArrayList<>();

        String sql = "SELECT d.id, d.fecha_registro, u.nombres, o.nombre_olla, d.mensaje, d.estado " +
                     "FROM Donacion d " +
                     "INNER JOIN Olla_Comun o ON d.olla_id = o.id " +
                     "INNER JOIN Usuario u ON d.donador_id = u.id " +
                     "ORDER BY d.fecha_registro DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                String[] fila = new String[6];
                fila[0] = String.valueOf(rs.getInt("id")); // Necesitamos el ID para actualizar
                fila[1] = rs.getString("fecha_registro");
                fila[2] = rs.getString("nombres");
                fila[3] = rs.getString("nombre_olla");
                fila[4] = rs.getString("mensaje");
                fila[5] = rs.getString("estado");
                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("Error listarTodasLasDonacionesAdmin: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }

    // 6. CAMBIAR EL ESTADO DE UNA DONACIÓN (Admin)
    public boolean cambiarEstadoDonacion(int idDonacion, String nuevoEstado) {
        String sql = "UPDATE Donacion SET estado = ? WHERE id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idDonacion);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en cambiarEstadoDonacion: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }

    private void cerrarConexiones() {
        try {
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(con != null) con.close();
        } catch (SQLException e) { }
    }
}
