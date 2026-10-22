/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

import dao.RecursoDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RecursoControlador", urlPatterns = {"/RecursoControlador"})
public class RecursoControlador extends HttpServlet {

    RecursoDAO recursoDao = new RecursoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("registrarAlmacenGeneral".equals(accion)) {
            String nombre = request.getParameter("nombreRecurso");
            double cantidad = Double.parseDouble(request.getParameter("cantidad"));
            String unidad = request.getParameter("unidadMedida");

            recursoDao.agregarAlmacenGeneral(nombre, cantidad, unidad);
            response.sendRedirect("admin_recursos.jsp?exito=true");

        } else if ("editarAlmacenGeneral".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("idRecurso"));
            String nombre = request.getParameter("nombreRecurso");
            double cantidad = Double.parseDouble(request.getParameter("cantidad"));
            String unidad = request.getParameter("unidadMedida");

            recursoDao.actualizarRecurso(id, nombre, cantidad, unidad);
            response.sendRedirect("admin_recursos.jsp?exito=true");

        } else if ("eliminarAlmacenGeneral".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("idRecurso"));
            recursoDao.eliminarRecurso(id);
            response.sendRedirect("admin_recursos.jsp?exito=true");
        }
    }
}