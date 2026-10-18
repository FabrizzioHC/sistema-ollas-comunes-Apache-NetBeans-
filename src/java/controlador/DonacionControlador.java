/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.DonacionDAO;
import modelo.Donacion;
import modelo.Usuario;

/**
 *
 * @author FABRIZZIO
 */
@WebServlet(name = "DonacionControlador", urlPatterns = {"/DonacionControlador"})
public class DonacionControlador extends HttpServlet {

    DonacionDAO donacionDao = new DonacionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if (accion.equalsIgnoreCase("registrarDonacion")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");

            if (usu != null && usu.getRol().equalsIgnoreCase("DONADOR")) {
                
                int ollaId = Integer.parseInt(request.getParameter("olla_comun_id"));
                String tipo = request.getParameter("tipo_recurso");
                String cantidad = request.getParameter("cantidad");
                String unidad = request.getParameter("unidad");
                String desc = request.getParameter("descripcion");

                // Juntamos todo en un solo string para guardarlo en la tabla Donacion
                String mensajeFinal = tipo.toUpperCase() + ": " + cantidad + " " + unidad + ". Nota: " + desc;

                Donacion d = new Donacion();
                d.setDonadorId(usu.getId());
                d.setOllaId(ollaId);
                d.setMensaje(mensajeFinal);

            if (donacionDao.registrarDonacion(d)) {
                response.sendRedirect("mis_donaciones.jsp?exito=true");
            } else {
                response.sendRedirect("mis_donaciones.jsp?error=true");
            }
            } else {
                response.sendRedirect("index.jsp");
            }
        }

        // FLUJO: CAMBIAR ESTADO DE DONACIÓN (ADMIN)
        else if (accion.equalsIgnoreCase("cambiarEstadoDonacion")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");

            // Validamos que sea el administrador
            if (usu != null && usu.getRol().equalsIgnoreCase("ADMIN")) {
                int idDonacion = Integer.parseInt(request.getParameter("idDonacion"));
                String nuevoEstado = request.getParameter("nuevoEstado");

                if (donacionDao.cambiarEstadoDonacion(idDonacion, nuevoEstado)) {
                    response.sendRedirect("admin_donaciones.jsp?exito=true");
                } else {
                    response.sendRedirect("admin_donaciones.jsp?error=true");
                }
            } else {
                response.sendRedirect("index.jsp");
            }
        }
    }
}
