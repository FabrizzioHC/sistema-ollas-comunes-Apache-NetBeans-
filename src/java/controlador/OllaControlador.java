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

    // READ: listado y búsqueda de ollas desde MySQL (sin SQL en el JSP).
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession sesion = request.getSession(false);
        Usuario admin = sesion == null ? null : (Usuario) sesion.getAttribute("usuarioLogueado");
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
            response.sendRedirect("index.jsp");
            return;
        }
        request.setCharacterEncoding("UTF-8");
        String q = request.getParameter("q");
        q = q == null ? "" : q.trim();
        if (q.length() > 100) q = q.substring(0, 100);
        request.setAttribute("terminoBusqueda", q);
        request.setAttribute("listaOllas", q.isEmpty()
                ? ollaDao.listarTodasAdmin() : ollaDao.buscarOllasAdmin(q));
        request.setAttribute("lideresasDisponibles", ollaDao.listarLideresasSinOlla());
        request.getRequestDispatcher("/admin_ollas.jsp").forward(request, response);
    }

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
        
        // FLUJO: AGREGAR OLLA COMÚN (SOLO ADMIN)
        else if (accion.equalsIgnoreCase("agregarOllaAdmin")) {
            HttpSession session = request.getSession(false);
            Usuario administrador = session == null ? null : (Usuario) session.getAttribute("usuarioLogueado");
            if (administrador == null || !"ADMIN".equalsIgnoreCase(administrador.getRol())) {
                response.sendRedirect("index.jsp");
                return;
            }

            try {
                String nombre = request.getParameter("nombre_olla");
                String direccion = request.getParameter("direccion");
                String descripcion = request.getParameter("descripcion");
                String estado = request.getParameter("estado");
                int lideresaId = Integer.parseInt(request.getParameter("usuario_id"));
                int beneficiarios = Integer.parseInt(request.getParameter("beneficiarios"));
                nombre = nombre == null ? "" : nombre.trim();
                direccion = direccion == null ? "" : direccion.trim();
                descripcion = descripcion == null ? "" : descripcion.trim();
                estado = estado == null ? "" : estado.trim();

                boolean estadoValido = "ACTIVA".equals(estado) || "PAUSADA".equals(estado)
                        || "INACTIVA".equals(estado);
                if (lideresaId <= 0 || nombre.isEmpty() || nombre.length() > 150
                        || direccion.isEmpty() || direccion.length() > 255
                        || descripcion.length() > 2000 || beneficiarios < 0 || beneficiarios > 1000000
                        || !estadoValido) {
                    response.sendRedirect("admin_ollas.jsp?errorAgregar=true");
                    return;
                }

                OllaComun nuevaOlla = new OllaComun();
                nuevaOlla.setUsuarioId(lideresaId);
                nuevaOlla.setNombreOlla(nombre);
                nuevaOlla.setDireccion(direccion);
                nuevaOlla.setDescripcion(descripcion);
                nuevaOlla.setBeneficiariosAtendidos(beneficiarios);
                nuevaOlla.setEstado(estado);

                if (ollaDao.registrarOllaAdmin(nuevaOlla)) {
                    response.sendRedirect("admin_ollas.jsp?agregado=true");
                } else {
                    response.sendRedirect("admin_ollas.jsp?errorAgregar=true");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("admin_ollas.jsp?errorAgregar=true");
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

