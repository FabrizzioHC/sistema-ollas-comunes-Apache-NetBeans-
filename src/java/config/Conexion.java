/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 *
 * @author FABRIZZIO
 */
public class Conexion {
    
    private Connection con;
    private static final String URL = "jdbc:mysql://localhost:3306/sistema_ollas_comunes?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "juanparis";

    public Connection getConnection() {
        try {
            // Cargar el driver de MySQL en memoria
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Establecer la conexión
            con = DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException e) {
            System.err.println("Error: No se encontró el driver de MySQL - " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Error de conexión a la Base de Datos - " + e.getMessage());
        }
        return con;
    }
    
// --- MÉTODO DE PRUEBA ---
    public static void main(String[] args) {
        Conexion prueba = new Conexion();
        Connection cn = prueba.getConnection();
        
        if (cn != null) {
            System.out.println("¡ÉXITO! Conexión perfecta a la base de datos sistema_ollas_comunes.");
        } else {
            System.out.println("¡ERROR! No se pudo conectar. Revisa que tu MySQL esté encendido y tus credenciales sean correctas.");
        }
    }
}