<%-- 
    Document   : ollas
    Created on : 18 oct. 2026, 1:51:24 p. m.
    Author     : FABRIZZIO
--%>

<%@page import="java.util.List"%>
<%@page import="dao.OllaDAO"%>
<%@page import="modelo.OllaComun"%>
<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    
    OllaDAO oDao = new OllaDAO();
    List<OllaComun> listaOllas = oDao.listarTodasLasOllasPublicas();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Nuestras Ollas Comunes - Red Comunitaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .hover-card { transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .hover-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }
    </style>
</head>
<body class="bg-light">

    <!-- Copiamos el mismo Navbar de tu donar.jsp -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary py-3 shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold text-white" href="index.jsp">
                <span class="logo-icon">❤️</span>
                <span class="text-white">Red</span>Comunitaria
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link text-white" href="index.jsp">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link text-white fw-bold" href="ollas.jsp">Ollas Comunes</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="donar.jsp">Donar Ahora</a></li>
                    <li class="nav-item ms-3 d-flex align-items-center gap-2">
                        <% if (usu != null) { %>
                            <a href="dashboard.jsp" class="btn btn-light btn-sm text-primary fw-bold">Mi Perfil</a>
                            <a href="UsuarioControlador?accion=logout" class="btn btn-danger btn-sm ms-2">Cerrar Sesión</a>
                        <% } else { %>
                            <a href="login.jsp" class="btn btn-outline-light btn-sm">Iniciar Sesión</a>
                            <a href="registro.jsp" class="btn btn-light btn-sm text-primary fw-bold">Registrarse</a>
                        <% } %>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Header -->
    <section class="bg-white text-center py-5 shadow-sm mb-5">
        <div class="container">
            <h1 class="display-5 fw-bold text-primary mb-3">Nuestras Ollas Comunes</h1>
            <p class="lead text-muted">Conoce a las organizaciones de base que alimentan a nuestra comunidad día a día.</p>
        </div>
    </section>

    <!-- Grilla de Tarjetas -->
    <div class="container pb-5">
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            
            <% if(listaOllas != null && !listaOllas.isEmpty()) { 
                for(OllaComun olla : listaOllas) { %>
                
                <div class="col">
                    <div class="card h-100 shadow-sm border-0 rounded-4 hover-card">
                        <!-- Cabecera de la Tarjeta con ícono -->
                        <div class="card-header bg-primary text-white text-center py-4 border-0 rounded-top-4">
                            <i class="bi bi-house-heart-fill display-4"></i>
                        </div>
                        
                        <div class="card-body p-4 text-center">
                            <h4 class="card-title fw-bold text-dark mb-3"><%= olla.getNombreOlla() %></h4>
                            
                            <!-- Descripción (si está vacía ponemos un mensaje por defecto) -->
                            <p class="card-text text-muted small mb-4">
                                <%= (olla.getDescripcion() != null && !olla.getDescripcion().isEmpty()) 
                                    ? olla.getDescripcion() 
                                    : "Olla común al servicio de la comunidad, brindando apoyo alimentario a quienes más lo necesitan." %>
                            </p>
                            
                            <hr class="text-muted opacity-25">
                            
                            <!-- Datos Extra -->
                            <div class="d-flex flex-column align-items-center gap-2 mt-3">
                                <span class="badge bg-light text-dark border p-2 w-100 text-start">
                                    <i class="bi bi-geo-alt-fill text-danger me-2"></i> <%= olla.getDireccion() %>
                                </span>
                                <span class="badge bg-light text-dark border p-2 w-100 text-start">
                                    <i class="bi bi-people-fill text-info me-2"></i> <%= olla.getBeneficiariosAtendidos() %> beneficiarios
                                </span>
                            </div>
                        </div>
                        
                        <!-- Footer con Botón de Ayuda -->
                        <div class="card-footer bg-white border-0 p-4 pt-0">
                            <a href="donar.jsp" class="btn btn-outline-primary w-100 rounded-pill fw-bold shadow-sm">
                                <i class="bi bi-heart-fill me-2"></i>¡Quiero Apoyar!
                            </a>
                        </div>
                    </div>
                </div>
                
            <%  } 
               } else { %>
                <div class="col-12 text-center py-5">
                    <h4 class="text-muted">Aún no hay ollas comunes registradas en la red.</h4>
                </div>
            <% } %>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
