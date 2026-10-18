<%-- 
    Document   : dashboard
    Created on : 16 oct. 2026, 12:00:26 p. m.
    Author     : FABRIZZIO
--%>

<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    if (usu == null) {
        response.sendRedirect("index.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Red Comunitaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css"> <!-- Nuestro CSS -->
</head>
<body style="background-color: #f8f9fa;">

    <!-- Inyectamos la barra superior y el menú lateral -->
    <%@include file="includes/topbar.jsp" %>
    <%@include file="includes/sidebar.jsp" %>

    <!-- CONTENIDO PRINCIPAL -->
    <div class="container-fluid p-4">
        <h2 class="mb-4 fw-bold">Panel Principal</h2>
        
        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4">
                <h5 class="card-title">Bienvenido, <%= usu.getNombres() %></h5>
                <p>Este es el panel principal. Aquí colocaremos las gráficas o tablas según tu rol.</p>
                <span class="badge bg-primary">Rol: <%= usu.getRol() %></span>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
