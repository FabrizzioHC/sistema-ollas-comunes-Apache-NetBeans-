<%-- 
    Document   : topbar
    Created on : 16 oct. 2026, 1:44:49 p. m.
    Author     : FABRIZZIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="topbar d-flex justify-content-between align-items-center shadow-sm">
    <div class="d-flex align-items-center">
        <button class="btn-hamburger" data-bs-toggle="offcanvas" data-bs-target="#menuLateral">
            <i class="bi bi-list fs-4"></i>
        </button>
        <!-- Convertimos el texto en un enlace sin subrayado -->
        <a href="index.jsp" class="brand-text text-decoration-none">RedComunitaria</a>
    </div>
    <div class="d-flex align-items-center gap-3">
        <span class="text-muted d-none d-md-inline"><%= usu.getEmail() %></span>
        <a href="UsuarioControlador?accion=logout" class="btn btn-outline-danger btn-sm">Cerrar Sesión</a>
    </div>
</div>
