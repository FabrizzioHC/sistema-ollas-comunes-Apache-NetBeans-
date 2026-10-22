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
import dao.UsuarioDAO;
import modelo.Usuario;
import modelo.OllaComun;


/**
 *
 * @author FABRIZZIO
 */
@WebServlet(name = "UsuarioControlador", urlPatterns = {"/UsuarioControlador"})
public class UsuarioControlador extends HttpServlet {

    UsuarioDAO dao = new UsuarioDAO();

@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        if (accion != null && accion.equalsIgnoreCase("logout")) {
            // Obtenemos la sesión actual sin crear una nueva (false)
            HttpSession session = request.getSession(false);
            
            if (session != null) {
                // Destruimos la sesión y todos sus datos
                session.invalidate();
            }
            
            // Redirigimos al usuario a la Landing Page pública
            response.sendRedirect("index.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configurar el encoding para que las tildes y eñes se guarden bien
        request.setCharacterEncoding("UTF-8");
        
        String accion = request.getParameter("accion");
        
        // FLUJO 1: INICIAR SESIÓN
        if (accion.equalsIgnoreCase("login")) {
            String email = request.getParameter("email");
            String pass = request.getParameter("password");
            
            Usuario usu = dao.iniciarSesion(email, pass);
            
            if (usu != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogueado", usu);
                response.sendRedirect("index.jsp"); 
            } else {
                request.setAttribute("error", "Correo o contraseña incorrectos.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } 
        
        // FLUJO 2: REGISTRAR OLLA COMÚN 
        else if (accion.equalsIgnoreCase("registrar")) {
            
            // 1. Capturamos los datos básicos del usuario
            Usuario usu = new Usuario();
            usu.setEmail(request.getParameter("email"));
            usu.setPasswordHash(request.getParameter("password"));
            usu.setNombres(request.getParameter("nombres"));
            usu.setApellidos(request.getParameter("apellidos"));
            usu.setTelefono(request.getParameter("telefono"));
            usu.setDni(request.getParameter("dni"));
            
            String rol = request.getParameter("rol"); 
            usu.setRol(rol); // "LIDERESA" o "DONADOR" --> por el momento xd ya de ahi añadiremos al beneficiario pero primero empezaremos con estos 2 roles para no complicarnos
            
            boolean registroExitoso = false;

            // 2. Evaluamos qué rol tiene para decidir cómo guardarlo
            if (rol.equalsIgnoreCase("LIDERESA")) {
                // Capturamos los datos extra del formulario
                OllaComun olla = new OllaComun();
                olla.setNombreOlla(request.getParameter("nombreOlla"));
                olla.setDireccion(request.getParameter("direccionOlla"));
                olla.setDescripcion(request.getParameter("descripcionOlla"));
                
                // Llamamos al método transaccional del DAO
                registroExitoso = dao.registrarLideresaConOlla(usu, olla);
                
            } else {
                // Es un donador, usamos el registro normal
                registroExitoso = dao.registrarUsuario(usu);
            }
            
            // 3. Respondemos al usuario según el resultado
            if (registroExitoso) {
                request.setAttribute("mensaje", "Registro exitoso. ¡Ahora puedes iniciar sesión!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Error al registrar. Verifica que el correo o DNI no estén en uso.");
                // Si falla, lo devolvemos al registro, no al login
                request.getRequestDispatcher("registro.jsp").forward(request, response);
            }
        }
        
        // FLUJO 3: ACTUALIZAR PERFIL
        else if (accion.equalsIgnoreCase("actualizarPerfil")) {
            // Recuperamos el usuario que está actualmente en la sesión
            HttpSession session = request.getSession();
            Usuario usuLogueado = (Usuario) session.getAttribute("usuarioLogueado");
            
            if (usuLogueado != null) {
                // Actualizamos el objeto con los nuevos datos del formulario
                usuLogueado.setNombres(request.getParameter("nombres"));
                usuLogueado.setApellidos(request.getParameter("apellidos"));
                usuLogueado.setTelefono(request.getParameter("telefono"));
                usuLogueado.setDni(request.getParameter("dni"));
                
                // Llamamos al DAO para que guarde en la BD
                if (dao.actualizarUsuario(usuLogueado)) {
                    // Refrescamos la sesión con los nuevos datos para que la vista se actualice al instante
                    session.setAttribute("usuarioLogueado", usuLogueado);
                    // Recargamos la página enviando un parámetro de éxito en la URL
                    response.sendRedirect("perfil.jsp?exito=true");
                } else {
                    response.sendRedirect("perfil.jsp?error=true");
                }
            } else {
                response.sendRedirect("index.jsp");
            }
        }
        
        // FLUJO: EDITAR USUARIO (SOLO ADMIN)
        else if (accion.equalsIgnoreCase("editarUsuarioAdmin")) {
            HttpSession session = request.getSession();
            Usuario usuLogueado = (Usuario) session.getAttribute("usuarioLogueado");

            if (usuLogueado != null && usuLogueado.getRol().equalsIgnoreCase("ADMIN")) {
                Usuario u = new Usuario();
                u.setId(Integer.parseInt(request.getParameter("idUsuario")));
                u.setNombres(request.getParameter("nombres"));
                u.setApellidos(request.getParameter("apellidos"));
                u.setEmail(request.getParameter("email"));
                u.setRol(request.getParameter("rol"));
                u.setTelefono(request.getParameter("telefono"));
                u.setDni(request.getParameter("dni"));

                if (dao.actualizarUsuarioAdmin(u)) { //verificar si esta bien lo de "dao" antes usuDAO
                    response.sendRedirect("admin_usuarios.jsp?exito=true");
                } else {
                    response.sendRedirect("admin_usuarios.jsp?error=true");
                }
            } else {
                response.sendRedirect("index.jsp");
            }
        }
        
        // FLUJO: ELIMINAR OLLA (SOLO ADMIN) ------ TEST
        else if (accion.equalsIgnoreCase("eliminarUsuarioAdmin")) {
            HttpSession session = request.getSession();
            Usuario usuLogueado = (Usuario) session.getAttribute("usuarioLogueado");

            if (usuLogueado != null && usuLogueado.getRol().equalsIgnoreCase("ADMIN")) {
                int idUsu = Integer.parseInt(request.getParameter("idUsu"));
                
                if (dao.eliminarUsuarioAdmin(idUsu)) {
                    response.sendRedirect("admin_usuarios.jsp?exito=true");
                } else {
                    response.sendRedirect("admin_usuarios.jsp?errorFk=true");
                }
            } else {
                response.sendRedirect("index.jsp");
            }
        }
        
        // Agregar Usuario Admin
        else if (accion.equalsIgnoreCase("agregarUsuarioAdmin")) {
            HttpSession session = request.getSession(false);
            Usuario admin = (session == null) ? null : (Usuario) session.getAttribute("usuarioLogueado");

            if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
            response.sendRedirect("index.jsp");
            return;
            }

            String nombres = request.getParameter("nombres").trim();
            String apellidos = request.getParameter("apellidos").trim();
            String email = request.getParameter("email").trim();
            String dni = request.getParameter("dni").trim();
            String telefono = request.getParameter("telefono") != null ? request.getParameter("telefono").trim() : "";
            String rol = request.getParameter("rol").trim();
            String password = request.getParameter("password");

            Usuario nuevo = new Usuario();
            nuevo.setNombres(nombres);
            nuevo.setApellidos(apellidos);
            nuevo.setEmail(email);
            nuevo.setDni(dni);
            nuevo.setTelefono(telefono);
            nuevo.setRol(rol);
            nuevo.setPasswordHash(password);

            if (dao.registrarUsuario(nuevo)) {
            response.sendRedirect("admin_usuarios.jsp?agregado=true");
            } else {
            response.sendRedirect("admin_usuarios.jsp?errorAgregar=true");
            }
        }
    }
}
