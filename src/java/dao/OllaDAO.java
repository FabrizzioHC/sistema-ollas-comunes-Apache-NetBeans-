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
import modelo.OllaComun;
import modelo.Recurso;
/**
 *
 * @author FABRIZZIO
 */
public class OllaDAO {
    
    private Conexion cn = new Conexion();
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    // 1. OBTENER LA OLLA COMÚN DE UNA LIDERESA
    public OllaComun obtenerOllaPorLideresaId(int idLideresa) {
        OllaComun olla = null;
        String sql = "SELECT * FROM Olla_Comun WHERE usuario_id = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idLideresa);
            rs = ps.executeQuery();
            if (rs.next()) {
                olla = new OllaComun();
                olla.setId(rs.getInt("id"));
                olla.setUsuarioId(rs.getInt("usuario_id"));
                olla.setNombreOlla(rs.getString("nombre_olla"));
                olla.setDireccion(rs.getString("direccion"));
                olla.setDescripcion(rs.getString("descripcion"));
                olla.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerOlla: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return olla;
    }

    // 2. AGREGAR UN NUEVO RECURSO AL INVENTARIO
    public boolean registrarRecurso(Recurso r) {
        String sql = "INSERT INTO Recurso (olla_id, nombre_recurso, cantidad, unidad_medida) VALUES (?, ?, ?, ?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, r.getOllaId());
            ps.setString(2, r.getNombreRecurso());
            ps.setDouble(3, r.getCantidad());
            ps.setString(4, r.getUnidadMedida());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en registrarRecurso: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }

    // 3. LISTAR TODOS LOS RECURSOS DE UNA OLLA
    public List<Recurso> listarRecursosPorOlla(int ollaId) {
        List<Recurso> lista = new ArrayList<>();
        String sql = "SELECT * FROM Recurso WHERE olla_id = ? ORDER BY fecha_actualizacion DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, ollaId);
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
        } catch (SQLException e) {
            System.err.println("Error en listarRecursos: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }

    // 4. LISTAR TODAS LAS OLLAS PARA LA VISTA PÚBLICA
    public List<modelo.OllaComun> listarTodasLasOllasPublicas() {
        List<modelo.OllaComun> lista = new ArrayList<>();
        String sql = "SELECT * FROM Olla_Comun WHERE estado = 'ACTIVA' ORDER BY fecha_creacion DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                modelo.OllaComun olla = new modelo.OllaComun();
                olla.setId(rs.getInt("id"));
                olla.setNombreOlla(rs.getString("nombre_olla"));
                olla.setDireccion(rs.getString("direccion"));
                olla.setDescripcion(rs.getString("descripcion"));
                olla.setBeneficiariosAtendidos(rs.getInt("beneficiarios_atendidos"));
                lista.add(olla);
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodasLasOllasPublicas: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }
    
    // 5. LISTAR TODAS LAS OLLAS PARA EL ADMIN
    public List<modelo.OllaComun> listarTodasAdmin() {
        List<modelo.OllaComun> lista = new ArrayList<>();
        String sql = "SELECT * FROM Olla_Comun ORDER BY id DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                modelo.OllaComun olla = new modelo.OllaComun();
                olla.setId(rs.getInt("id"));
                olla.setNombreOlla(rs.getString("nombre_olla"));
                olla.setDireccion(rs.getString("direccion"));
                olla.setDescripcion(rs.getString("descripcion"));
                olla.setBeneficiariosAtendidos(rs.getInt("beneficiarios_atendidos"));
                olla.setEstado(rs.getString("estado"));
                lista.add(olla);
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodasAdmin: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }

    // 6. ACTUALIZAR OLLA (ADMIN)
    public boolean actualizarOllaAdmin(modelo.OllaComun olla) {
        String sql = "UPDATE Olla_Comun SET nombre_olla=?, direccion=?, descripcion=?, beneficiarios_atendidos=?, estado=? WHERE id=?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, olla.getNombreOlla());
            ps.setString(2, olla.getDireccion());
            ps.setString(3, olla.getDescripcion());
            ps.setInt(4, olla.getBeneficiariosAtendidos());
            ps.setString(5, olla.getEstado());
            ps.setInt(6, olla.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error actualizarOllaAdmin: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }

    // 7. ELIMINAR OLLA (ADMIN)
    public boolean eliminarOllaAdmin(int idOlla) {
        String sql = "DELETE FROM Olla_Comun WHERE id=?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idOlla);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error eliminarOllaAdmin: " + e.getMessage());
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
        } catch (SQLException e) {
            System.err.println("Error cerrando conexiones: " + e);
        }
    }
}