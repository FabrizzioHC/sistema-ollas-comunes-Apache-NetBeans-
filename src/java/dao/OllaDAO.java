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
import modelo.Usuario;
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
    
    // 4. REGISTRAR UNA SOLICITUD DE AYUDA
    public boolean registrarSolicitud(modelo.Solicitud s) {
        String sql = "INSERT INTO Solicitud (olla_id, recurso_necesitado, cantidad_necesitada, unidad_medida, nivel_urgencia, estado) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, s.getOllaId());
            ps.setString(2, s.getRecursoNecesitado());
            ps.setDouble(3, s.getCantidadNecesitada());
            ps.setString(4, s.getUnidadMedida());
            ps.setString(5, s.getNivelUrgencia());
            ps.setString(6, "Pendiente"); // Toda solicitud nace en estado Pendiente
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en registrarSolicitud: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }

    // 5. LISTAR SOLICITUDES POR OLLA
    public List<modelo.Solicitud> listarSolicitudesPorOlla(int ollaId) {
        List<modelo.Solicitud> lista = new ArrayList<>();
        String sql = "SELECT * FROM Solicitud WHERE olla_id = ? ORDER BY fecha_solicitud DESC";
        
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, ollaId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                modelo.Solicitud s = new modelo.Solicitud();
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
            System.err.println("Error en listarSolicitudes: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }
    
    // 6. LISTAR TODAS LAS SOLICITUDES PARA EL ADMINISTRADOR (Con el nombre de la olla)
    public List<modelo.Solicitud> listarTodasLasSolicitudes() {
        List<modelo.Solicitud> lista = new ArrayList<>();
        String sql = "SELECT s.*, o.nombre_olla FROM Solicitud s INNER JOIN Olla_Comun o ON s.olla_id = o.id ORDER BY s.fecha_solicitud DESC";
        
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                modelo.Solicitud s = new modelo.Solicitud();
                s.setId(rs.getInt("id"));
                s.setOllaId(rs.getInt("olla_id"));
                s.setRecursoNecesitado(rs.getString("recurso_necesitado"));
                s.setCantidadNecesitada(rs.getDouble("cantidad_necesitada"));
                s.setUnidadMedida(rs.getString("unidad_medida"));
                s.setNivelUrgencia(rs.getString("nivel_urgencia"));
                s.setEstado(rs.getString("estado"));
                s.setFechaSolicitud(rs.getTimestamp("fecha_solicitud"));
                s.setNombreOlla(rs.getString("nombre_olla")); // Guardamos el nombre extraído del JOIN
                lista.add(s);
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodasLasSolicitudes: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }

    // 7. CAMBIAR EL ESTADO DE UNA SOLICITUD (Aceptar o Rechazar)
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

    // 8. LISTAR TODAS LAS OLLAS PARA LA VISTA PÚBLICA
    public List<modelo.OllaComun> listarTodasLasOllasPublicas() {
        List<modelo.OllaComun> lista = new ArrayList<>();
        // Solo mostramos las que están activas
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
    
    // 9. LISTAR TODAS LAS OLLAS PARA EL ADMIN (Sin filtro de estado)
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

    // 10. ACTUALIZAR OLLA (ADMIN)
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

    // 11. ELIMINAR OLLA (ADMIN)
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
    

    // NUEVO: LIDERESAS ACTIVAS QUE TODAVÍA NO TIENEN OLLA ASIGNADA
    public List<Usuario> listarLideresasSinOlla() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.id, u.nombres, u.apellidos, u.email "
                + "FROM Usuario u WHERE u.rol = 'LIDERESA' AND u.activo = 1 "
                + "AND NOT EXISTS (SELECT 1 FROM Olla_Comun o WHERE o.usuario_id = u.id) "
                + "ORDER BY u.nombres, u.apellidos";
        try (Connection conexion = cn.getConnection();
             PreparedStatement stmt = conexion.prepareStatement(sql);
             ResultSet resultados = stmt.executeQuery()) {
            while (resultados.next()) {
                Usuario lideresa = new Usuario();
                lideresa.setId(resultados.getInt("id"));
                lideresa.setNombres(resultados.getString("nombres"));
                lideresa.setApellidos(resultados.getString("apellidos"));
                lideresa.setEmail(resultados.getString("email"));
                lista.add(lideresa);
            }
        } catch (SQLException e) {
            System.err.println("Error en listarLideresasSinOlla: " + e.getMessage());
        }
        return lista;
    }

    // READ: buscar ollas comunes en MySQL por nombre, dirección, estado o beneficiarios.
    public List<OllaComun> buscarOllasAdmin(String texto) {
        List<OllaComun> resultado = new ArrayList<>();
        String sql = "SELECT * FROM Olla_Comun WHERE "
                + "nombre_olla LIKE ? OR direccion LIKE ? OR estado LIKE ? "
                + "OR CAST(beneficiarios_atendidos AS CHAR) LIKE ? ORDER BY id DESC";
        String patron = "%" + texto + "%";
        try (Connection conexion = cn.getConnection();
             PreparedStatement sentencia = conexion.prepareStatement(sql)) {
            for (int i = 1; i <= 4; i++) sentencia.setString(i, patron);
            try (ResultSet rsBusqueda = sentencia.executeQuery()) {
                while (rsBusqueda.next()) {
                    OllaComun olla = new OllaComun();
                    olla.setId(rsBusqueda.getInt("id"));
                    olla.setNombreOlla(rsBusqueda.getString("nombre_olla"));
                    olla.setDireccion(rsBusqueda.getString("direccion"));
                    olla.setDescripcion(rsBusqueda.getString("descripcion"));
                    olla.setBeneficiariosAtendidos(rsBusqueda.getInt("beneficiarios_atendidos"));
                    olla.setEstado(rsBusqueda.getString("estado"));
                    resultado.add(olla);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar ollas: " + e.getMessage());
        }
        return resultado;
    }

    // NUEVO: REGISTRAR UNA OLLA DESDE ADMINISTRACIÓN EN MYSQL
    public boolean registrarOllaAdmin(OllaComun olla) {
        // Inserta solo si el usuario realmente es una lideresa activa y está sin olla.
        String sql = "INSERT INTO Olla_Comun "
                + "(usuario_id, nombre_olla, descripcion, direccion, beneficiarios_atendidos, estado) "
                + "SELECT u.id, ?, ?, ?, ?, ? FROM Usuario u "
                + "WHERE u.id = ? AND u.rol = 'LIDERESA' AND u.activo = 1 "
                + "AND NOT EXISTS (SELECT 1 FROM Olla_Comun o WHERE o.usuario_id = u.id)";
        try (Connection conexion = cn.getConnection();
             PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setString(1, olla.getNombreOlla());
            stmt.setString(2, olla.getDescripcion());
            stmt.setString(3, olla.getDireccion());
            stmt.setInt(4, olla.getBeneficiariosAtendidos());
            stmt.setString(5, olla.getEstado());
            stmt.setInt(6, olla.getUsuarioId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en registrarOllaAdmin: " + e.getMessage());
            return false;
        }
    }

    // Método auxiliar para cerrar conexiones
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