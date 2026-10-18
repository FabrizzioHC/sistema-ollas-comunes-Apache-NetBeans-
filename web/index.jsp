<%-- 
    Document   : index
    Created on : 16 oct. 2026, 11:56:36 a. m.
    Author     : FABRIZZIO
--%>

<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificamos si hay una sesión activa para cambiar los botones de la barra de navegación
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RedComunitaria | Inicio</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Nuestro CSS Global -->
    <link rel="stylesheet" href="assets/css/style.css">
    
    <style>
        /* Estilos base para complementar tus clases personalizadas */
        .hero-section {
            background: linear-gradient(135deg, #1e70e6 0%, #4da3ff 100%);
            color: white;
            padding: 80px 0;
            border-bottom-left-radius: 50px;
            border-bottom-right-radius: 50px;
        }
        .hero-badge {
            background: rgba(255,255,255,0.2);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            color: #333;
            transition: transform 0.3s;
        }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-value { font-size: 2rem; font-weight: bold; color: #1e70e6; }
        .feature-card {
            background: white;
            border: 1px solid #eee;
            border-radius: 15px;
            transition: all 0.3s;
            height: 100%;
        }
        .feature-card:hover { box-shadow: 0 10px 20px rgba(0,0,0,0.05); transform: translateY(-5px); }
        .feature-icon { font-size: 2.5rem; }
        .cta-section { background-color: #f8f9fa; }
    </style>
</head>
<body>
    
    <!-- BARRA DE NAVEGACIÓN -->
    <!-- Agregamos un fondo azul oscuro genérico a la barra para que el text-white resalte -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary py-3">
        <div class="container">
            <a class="navbar-brand fw-bold text-white" href="index.jsp">
                <span class="logo-icon">❤️</span>
                <span class="text-white">Red</span>Comunitaria
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-label="Abrir navegación">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="index.jsp">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a id="navOllas" class="nav-link text-white" href="ollas.jsp">Ollas Comunes</a>
                    </li>
                    <li class="nav-item">
                        <a id="navDonar" class="nav-link text-white" href="donar.jsp">Donar Ahora</a>
                    </li>
                    <li class="nav-item ms-3 d-flex align-items-center gap-2">
                        
                        <!-- LÓGICA JAVA PARA LOS BOTONES -->
                        <% if (usu != null) { %>
                            <!-- Si está logueado -->
                            <a href="dashboard.jsp" class="btn btn-light btn-sm text-primary fw-bold">Mi Perfil</a>
                            <a href="UsuarioControlador?accion=logout" class="btn btn-danger btn-sm ms-2">Cerrar Sesión</a>
                        <% } else { %>
                            <!-- Si es visitante -->
                            <a href="login.jsp" class="btn btn-outline-light btn-sm">Iniciar Sesión</a>
                            <a href="registro.jsp" class="btn btn-light btn-sm text-primary fw-bold">Registrarse</a>
                        <% } %>
                        
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <header class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7">
                    <span class="hero-badge">Conectando solidaridad con comunidad</span>
                    <h1 class="mt-4 fw-bold">Distribución Equitativa de Recursos en Ollas Comunes</h1>
                    <p class="lead mt-4 text-light">Plataforma digital que centraliza, organiza y transparenta la gestión de recursos para ollas comunes en el Perú.</p>
                    <div class="mt-5">
                        <a href="#" class="btn btn-light text-primary fw-bold px-4 py-2 me-3 rounded-pill">Ver Ollas Comunes</a>
                        <a href="#" class="btn btn-outline-light px-4 py-2 rounded-pill">Donar Ahora</a>
                    </div>
                </div>
                <div class="col-lg-5 mt-5 mt-lg-0">
                    <div class="card p-4 shadow-lg bg-white bg-opacity-90 border-0" style="border-radius: 2rem; backdrop-filter: blur(12px);">
                        <div class="text-center mb-4">
                            <h2 class="fw-bold text-dark">150+</h2>
                            <p class="mb-0 text-muted">Ollas Comunes activas</p>
                        </div>
                        <div class="text-center mb-4">
                            <h2 class="fw-bold text-dark">5,000+</h2>
                            <p class="mb-0 text-muted">Familias beneficiadas</p>
                        </div>
                        <div class="text-center">
                            <h2 class="fw-bold text-dark">98%</h2>
                            <p class="mb-0 text-muted">Transparencia</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row hero-stats mt-5">
                <div class="col-md-3 mb-3 mb-md-0">
                    <div class="stat-card p-4 text-center">
                        <span class="stat-value">150+</span>
                        <p class="mb-0 text-muted fw-bold">Ollas Comunes</p>
                    </div>
                </div>
                <div class="col-md-3 mb-3 mb-md-0">
                    <div class="stat-card p-4 text-center">
                        <span class="stat-value">5,000+</span>
                        <p class="mb-0 text-muted fw-bold">Familias</p>
                    </div>
                </div>
                <div class="col-md-3 mb-3 mb-md-0">
                    <div class="stat-card p-4 text-center">
                        <span class="stat-value">200+</span>
                        <p class="mb-0 text-muted fw-bold">Donantes</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card p-4 text-center">
                        <span class="stat-value">98%</span>
                        <p class="mb-0 text-muted fw-bold">Transparencia</p>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- SECCIÓN CÓMO FUNCIONA -->
    <section class="features-section py-5 bg-white">
        <div class="container my-4">
            <div class="text-center mb-5">
                <h2 class="fw-bold">¿Cómo Funciona?</h2>
                <p class="text-muted mx-auto" style="max-width: 640px;">Una plataforma completa para gestionar recursos de manera transparente y eficiente.</p>
            </div>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-card p-4 text-center">
                        <div class="feature-icon mb-3">📋</div>
                        <h5 class="fw-bold">Registro de Ollas Comunes</h5>
                        <p class="text-muted small">Registra y gestiona ollas con información actualizada sobre beneficiarios y ubicaciones.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card p-4 text-center">
                        <div class="feature-icon mb-3">🤝</div>
                        <h5 class="fw-bold">Sistema de Donaciones</h5>
                        <p class="text-muted small">Conecta donantes con comunidades de forma transparente y eficiente.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card p-4 text-center">
                        <div class="feature-icon mb-3">📌</div>
                        <h5 class="fw-bold">Geolocalización</h5>
                        <p class="text-muted small">Encuentra ollas comunes cercanas y visualiza su ubicación en tiempo real.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card p-4 text-center">
                        <div class="feature-icon mb-3">⚖️</div>
                        <h5 class="fw-bold">Distribución Equitativa</h5>
                        <p class="text-muted small">Asegura que los recursos lleguen a quienes más lo necesitan con priorización.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card p-4 text-center">
                        <div class="feature-icon mb-3">🔍</div>
                        <h5 class="fw-bold">Transparencia Total</h5>
                        <p class="text-muted small">Visibilidad completa de las donaciones y el destino de los recursos.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card p-4 text-center">
                        <div class="feature-icon mb-3">🔔</div>
                        <h5 class="fw-bold">Notificaciones</h5>
                        <p class="text-muted small">Recibe alertas sobre necesidades críticas y estados de solicitudes.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- LLAMADO A LA ACCIÓN -->
    <section class="cta-section py-5">
        <div class="container text-center py-4">
            <h2 class="fw-bold">Contribuye a la Reducción de Desigualdades</h2>
            <p class="lead mb-4 text-muted">Alinéate con el ODS 10 y ayuda a que la ayuda llegue a quienes más la necesitan.</p>
            <a href="donar.jsp" class="btn btn-primary px-5 py-3 rounded-pill fw-bold shadow">Comienza a Ayudar</a>
        </div>
    </section>

    <footer class="bg-dark text-white py-4 mt-auto">
        <div class="container text-center">
            <p class="mb-0 text-white-50">&copy; 2026 Red Comunitaria. Todos los derechos reservados.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>