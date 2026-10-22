/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import config.Conexion;
import modelo.Recurso;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List; 

public class RecursoDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // Obtener los recursos centrales (donde olla_id es NULL o 0)
    public List<Recurso> listarAlmacenGeneral() {
        List<Recurso> lista = new ArrayList<>();
        String sql = "SELECT * FROM recursos WHERE olla_id IS NULL OR olla_id = 0";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Recurso r = new Recurso();
                r.setId(rs.getInt("id"));
                r.setOllaId(rs.getInt("olla_id"));
                r.setNombreRecurso(rs.getString("nombre_recurso"));
                r.setCantidad(rs.getDouble("cantidad"));
                r.setUnidadMedida(rs.getString("unidad_medida"));
                r.setFechaActualizacion(rs.getTimestamp("fecha_actualizacion"));
                lista.add(r);
            }
        } catch (Exception e) {
            System.err.println("Error al listar almacén central: " + e.getMessage());
        }
        return lista;
    }

    public boolean agregarAlmacenGeneral(String nombre, double cantidad, String unidad) {
        String sql = "INSERT INTO recursos (olla_id, nombre_recurso, cantidad, unidad_medida, fecha_actualizacion) VALUES (NULL, ?, ?, ?, CURRENT_TIMESTAMP)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setDouble(2, cantidad);
            ps.setString(3, unidad);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al registrar en almacén: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarRecurso(int id, String nombre, double cantidad, String unidad) {
        String sql = "UPDATE recursos SET nombre_recurso = ?, cantidad = ?, unidad_medida = ?, fecha_actualizacion = CURRENT_TIMESTAMP WHERE id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setDouble(2, cantidad);
            ps.setString(3, unidad);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al actualizar: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarRecurso(int id) {
        String sql = "DELETE FROM recursos WHERE id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al eliminar: " + e.getMessage());
            return false;
        }
    }
}