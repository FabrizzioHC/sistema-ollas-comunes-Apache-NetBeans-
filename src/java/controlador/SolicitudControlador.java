/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import dao.SolicitudDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.Solicitud;
import modelo.Usuario;

/**
 *
 * @author FABRIZZIO
 */
@WebServlet(name = "SolicitudControlador", urlPatterns = {"/SolicitudControlador"})
public class SolicitudControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        SolicitudDAO solDao = new SolicitudDAO();

        // 1. OBTENER LA SESIÓN ACTUAL
        HttpSession session = request.getSession();
        Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");

        try {
            if (accion != null) {
                switch (accion) {
                    
                    // ==========================================
                    // FLUJOS DE LA LIDERESA
                    // ==========================================
                    case "crearSolicitud":
                        if (usu != null && usu.getRol().equalsIgnoreCase("LIDERESA")) {
                            Solicitud nueva = new Solicitud();
                            nueva.setOllaId(Integer.parseInt(request.getParameter("idOlla")));
                            nueva.setRecursoNecesitado(request.getParameter("recursoNecesitado"));
                            nueva.setCantidadNecesitada(Double.parseDouble(request.getParameter("cantidad")));
                            nueva.setUnidadMedida(request.getParameter("unidadMedida"));
                            nueva.setNivelUrgencia(request.getParameter("nivelUrgencia"));
                            
                            solDao.crearSolicitud(nueva);
                            response.sendRedirect("gestion_solicitudes.jsp?exito=true");
                        } else {
                            response.sendRedirect("index.jsp");
                        }
                        break;

                    case "actualizarSolicitud":
                        if (usu != null && usu.getRol().equalsIgnoreCase("LIDERESA")) {
                            Solicitud editada = new Solicitud();
                            editada.setId(Integer.parseInt(request.getParameter("idSolicitud")));
                            editada.setRecursoNecesitado(request.getParameter("recursoNecesitado"));
                            editada.setCantidadNecesitada(Double.parseDouble(request.getParameter("cantidad")));
                            editada.setUnidadMedida(request.getParameter("unidadMedida"));
                            editada.setNivelUrgencia(request.getParameter("nivelUrgencia"));
                            
                            solDao.actualizarSolicitud(editada);
                            response.sendRedirect("gestion_solicitudes.jsp?exito=true");
                        } else {
                            response.sendRedirect("index.jsp");
                        }
                        break;

                    case "eliminarSolicitud":
                        if (usu != null && usu.getRol().equalsIgnoreCase("LIDERESA")) {
                            int idEliminar = Integer.parseInt(request.getParameter("idSolicitud"));
                            solDao.eliminarSolicitud(idEliminar);
                            response.sendRedirect("gestion_solicitudes.jsp?exito=true");
                        } else {
                            response.sendRedirect("index.jsp");
                        }
                        break;

                    // ==========================================
                    // FLUJOS DEL ADMINISTRADOR
                    // ==========================================
                    case "cambiarEstadoSolicitud":
                        if (usu != null && usu.getRol().equalsIgnoreCase("ADMIN")) {
                            int idSolEstado = Integer.parseInt(request.getParameter("idSolicitud"));
                            String nuevoEstado = request.getParameter("nuevoEstado");
                            
                            solDao.cambiarEstadoSolicitud(idSolEstado, nuevoEstado);
                            response.sendRedirect("admin_solicitudes.jsp?exito=true");
                        } else {
                            response.sendRedirect("index.jsp");
                        }
                        break;

                    default:
                        response.sendRedirect("index.jsp");
                        break;
                }
            } else {
                response.sendRedirect("index.jsp");
            }
        } catch (Exception e) {
            System.err.println("Error en SolicitudControlador: " + e.getMessage());
            // Dependiendo del rol, lo mandamos a su página si hay error
            if (usu != null && usu.getRol().equalsIgnoreCase("ADMIN")) {
                response.sendRedirect("admin_solicitudes.jsp?error=true");
            } else {
                response.sendRedirect("gestion_solicitudes.jsp?error=true");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
