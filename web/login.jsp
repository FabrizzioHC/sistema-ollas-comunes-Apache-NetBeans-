<%-- 
    Document   : index
    Created on : 15 oct. 2026, 9:52:42 p. m.
    Author     : FABRIZZIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bienvenido - Sistema de Ollas Comunes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

    <!-- BARRA SUPERIOR -->
    <nav class="navbar navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <i class="bi bi-suit-heart-fill text-danger me-2"></i> RedComunitaria
            </a>
            <div>
                <a href="registro.jsp" class="btn-outline-light-custom">Registro</a>
            </div>
        </div>
    </nav>

    <!-- ÁREA CENTRAL CON EL FORMULARIO -->
    <div class="login-container">
        <div class="login-card">
            
            <div class="logo-box">
                <i class="bi bi-suit-heart-fill"></i>
            </div>
            
            <h4 class="fw-bold mb-2">Bienvenido a RedComunitaria</h4>
            <p class="text-muted small mb-4">Inicia sesión con tu correo y contraseña.</p>

            <!-- Alertas dinámicas -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger py-2 small" role="alert">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="alert alert-success py-2 small" role="alert">
                    <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>

            <!-- FORMULARIO -->
            <form action="UsuarioControlador" method="POST">
                <input type="hidden" name="accion" value="login">
                
                <input type="email" class="form-control" name="email" placeholder="Correo electrónico" required>
                <input type="password" class="form-control" name="password" placeholder="Contraseña" required>
                
                <button type="submit" class="btn btn-primary-custom">Iniciar Sesión</button>
            </form>

            <div class="mt-4 small">
                ¿No tienes cuenta? <a href="registro.jsp" class="text-decoration-none">Regístrate aquí</a>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
