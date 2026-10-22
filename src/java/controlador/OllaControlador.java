/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.OllaDAO;
import modelo.OllaComun;
import modelo.Recurso;
import modelo.Usuario;

/**
 *
 * @author FABRIZZIO
 */
@WebServlet(name = "OllaControlador", urlPatterns = {"/OllaControlador"})
public class OllaControlador extends HttpServlet {

    OllaDAO ollaDao = new OllaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");


        // METODO 1: AGREGAR UN RECURSO AL INVENTARIO
        if (accion.equalsIgnoreCase("agregarRecurso")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");

            // Solo una Lideresa puede agregar recursos
            if (usu != null && usu.getRol().equalsIgnoreCase("LIDERESA")) {
                
                // 1. Buscamos qué Olla le pertenece a esta lideresa
                OllaComun olla = ollaDao.obtenerOllaPorLideresaId(usu.getId());

                if (olla != null) {
                    // 2. Armamos el objeto Recurso con los datos del formulario
                    Recurso r = new Recurso();
                    r.setOllaId(olla.getId());
                    r.setNombreRecurso(request.getParameter("nombreRecurso"));
                    r.setCantidad(Double.parseDouble(request.getParameter("cantidad")));
                    r.setUnidadMedida(request.getParameter("unidadMedida"));

                    // 3. Guardamos en la Base de Datos
                    if (ollaDao.registrarRecurso(r)) {
                        response.sendRedirect("gestion_recursos.jsp?exito=true");
                    } else {
                        response.sendRedirect("gestion_recursos.jsp?error=true");
                    }
                }
            } else {
                //lo botamos al login
                response.sendRedirect("index.jsp");
            }
        }
        
        // FLUJO: EDITAR OLLA (SOLO ADMIN)
        else if (accion.equalsIgnoreCase("editarOllaAdmin")) {
            HttpSession session = request.getSession();
            Usuario usuLogueado = (Usuario) session.getAttribute("usuarioLogueado");

            if (usuLogueado != null && usuLogueado.getRol().equalsIgnoreCase("ADMIN")) {
                modelo.OllaComun olla = new modelo.OllaComun();
                olla.setId(Integer.parseInt(request.getParameter("idOlla")));
                olla.setNombreOlla(request.getParameter("nombre_olla"));
                olla.setDireccion(request.getParameter("direccion"));
                olla.setDescripcion(request.getParameter("descripcion"));
                olla.setBeneficiariosAtendidos(Integer.parseInt(request.getParameter("beneficiarios")));
                olla.setEstado(request.getParameter("estado"));

                if (ollaDao.actualizarOllaAdmin(olla)) {
                    response.sendRedirect("admin_ollas.jsp?exito=true");
                } else {
                    response.sendRedirect("admin_ollas.jsp?error=true");
                }
            } else {
                response.sendRedirect("index.jsp");
            }
        }
        
        // FLUJO: ELIMINAR OLLA (SOLO ADMIN)
        else if (accion.equalsIgnoreCase("eliminarOllaAdmin")) {
            HttpSession session = request.getSession();
            Usuario usuLogueado = (Usuario) session.getAttribute("usuarioLogueado");

            if (usuLogueado != null && usuLogueado.getRol().equalsIgnoreCase("ADMIN")) {
                int idOlla = Integer.parseInt(request.getParameter("idOlla"));
                
                if (ollaDao.eliminarOllaAdmin(idOlla)) {
                    response.sendRedirect("admin_ollas.jsp?exito=true");
                } else {
                    response.sendRedirect("admin_ollas.jsp?errorFk=true");
                }
            } else {
                response.sendRedirect("index.jsp");
            }
        }
    }
}
