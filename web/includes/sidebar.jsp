<%-- 
    Document   : sidebar
    Created on : 16 oct. 2026, 1:44:58 p. m.
    Author     : FABRIZZIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario" %>
<% Usuario usu = (Usuario) session.getAttribute("usuariologueado"); %>
<div class="offcanvas offcanvas-start" tabindex="-1" id="menuLateral" style="width: 280px;">
    <div class="offcanvas-header border-bottom">
        <h5 class="offcanvas-title text-primary fw-bold">RedComunitaria</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>
    </div>
    <div class="offcanvas-body p-3">
        
        <% if (usu.getRol().equalsIgnoreCase("ADMIN")) { %>
            <small class="text-muted fw-bold mb-2 d-block px-3">ADMINISTRADOR</small>
            <a href="dashboard.jsp" class="sidebar-link"><i class="bi bi-bar-chart-fill text-primary"></i> Dashboard General</a>
            <a href="admin_usuarios.jsp" class="sidebar-link"><i class="bi bi-people-fill text-purple"></i> Gestión Usuarios</a>
            <a href="admin_ollas.jsp" class="sidebar-link"><i class="bi bi-houses-fill text-primary"></i> Gestión de Ollas</a>
            <a href="admin_solicitudes.jsp" class="sidebar-link"><i class="bi bi-check-circle-fill text-success"></i> Solicitudes Pendientes</a>
            <a href="admin_donaciones.jsp" class="sidebar-link"><i class="bi bi-box-seam text-success"></i> Gestión de Donaciones</a>
            <a href="admin_recursos.jsp" class="sidebar-link"><i class="bi bi-boxes text-warning"></i> Almacén Central</a>
        <% } %>

        <% if (usu.getRol().equalsIgnoreCase("DONADOR")) { %>
            <small class="text-muted fw-bold mb-2 d-block px-3">DONADOR</small>
            <a href="dashboard.jsp" class="sidebar-link"><i class="bi bi-house-door-fill text-primary"></i> Inicio</a>
            <a href="mis_donaciones.jsp" class="sidebar-link"><i class="bi bi-gift-fill text-warning"></i> Mis Donaciones</a>
        <% } %>

        <% if (usu.getRol().equalsIgnoreCase("LIDERESA")) { %>
            <small class="text-muted fw-bold mb-2 d-block px-3">OLLA COMÚN</small>
            <a href="dashboard.jsp" class="sidebar-link"><i class="bi bi-shop text-primary"></i> Mi Olla Común</a>
            <a href="gestion_recursos.jsp" class="sidebar-link"><i class="bi bi-box-seam-fill text-brown"></i> Gestión de Recursos</a>
            <a href="gestion_solicitudes.jsp" class="sidebar-link"><i class="bi bi-megaphone-fill text-danger"></i> Solicitudes</a>
            <a href="#" class="sidebar-link"><i class="bi bi-people text-info"></i> Beneficiarios</a> <!--Falta agregar el rol Beneficiarios -->
        <% } %>

        <hr>
        <!-- Enlace hacia la nueva vista del perfil -->
        <a href="perfil.jsp" class="sidebar-link"><i class="bi bi-person-fill text-secondary"></i> Mi Perfil</a>
        
    </div>
</div>
