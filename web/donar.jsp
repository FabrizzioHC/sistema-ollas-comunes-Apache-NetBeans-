<%-- 
    Document   : donar
    Created on : 16 oct. 2026, 9:13:29 p. m.
    Author     : FABRIZZIO
--%>

<%@page import="modelo.OllaComun"%>
<%@page import="java.util.List"%>
<%@page import="dao.DonacionDAO"%>
<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificamos si hay alguien logueado para mostrar u ocultar el formulario
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    
    DonacionDAO dDao = new DonacionDAO();
    List<OllaComun> listaOllas = dDao.listarTodasOllas();
    List<String[]> donacionesGlobales = dDao.listarDonacionesAprobadasGlobales();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Hacer una Donación - Red Comunitaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

 
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

    <!-- Header -->
    <section class="bg-white text-center py-5 shadow-sm mb-5">
        <div class="container">
            <h1 class="display-5 fw-bold text-primary mb-3">Hacer una Donación</h1>
            <p class="lead text-muted">Tu aporte hace una diferencia real en nuestras comunidades.</p>
        </div>
    </section>

    <div class="container pb-5">
        <div class="row justify-content-center mb-4">
            <div class="col-md-8">
                <div class="alert alert-light border shadow-sm rounded-4 p-4">
                    <h5 class="mb-3 fw-bold text-primary"><i class="bi bi-info-circle-fill me-2"></i>Pasos para donar:</h5>
                    <ol class="mb-0 text-muted">
                        <li class="mb-1">Selecciona la olla común que deseas ayudar</li>
                        <li class="mb-1">Especifica el tipo y cantidad de recursos que donarás</li>
                        <li class="mb-1">Agrega detalles relevantes de la donación</li>
                        <li class="mb-1">Los administradores revisarán y aprobarán tu donación</li>
                        <li>Coordinaremos la entrega del recurso</li>
                    </ol>
                </div>
            </div>
        </div>
        <div class="row justify-content-center mb-5">
            <div class="col-md-8">
                <div class="card shadow border-0 rounded-4">
                    <div class="card-body p-5">
                        <h4 class="fw-bold mb-4"><i class="bi bi-box2-heart text-primary me-2"></i>Registra tu Donación</h4>

                        <% if (usu == null) { %>
                            <!-- Mensaje si no ha iniciado sesión (Basado en tu diseño original) -->
                            <div class="alert alert-info border-info d-flex align-items-center p-4 rounded-3" role="alert">
                                <i class="bi bi-info-circle-fill fs-4 me-3"></i>
                                <div>
                                    Para proteger las donaciones y llevar un registro seguro, por favor 
                                    <a href="login.jsp" class="alert-link">inicia sesión</a> o <a href="registro.jsp" class="alert-link">regístrate</a> como Donador.
                                </div>
                            </div>
                        <% } else if (!usu.getRol().equalsIgnoreCase("DONADOR") && !usu.getRol().equalsIgnoreCase("ADMIN")) { %>
                            <div class="alert alert-warning">Solo los usuarios con cuenta de 'Donador' pueden registrar donaciones.</div>
                        <% } else { %>
                            <!-- Formulario de Donación -->
                            <form action="DonacionControlador" method="POST">
                                <input type="hidden" name="accion" value="registrarDonacion">
                                
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">Selecciona una Olla Común *</label>
                                    <select class="form-select bg-light" name="olla_comun_id" required>
                                        <option value="">-- Selecciona una olla --</option>
                                        <% for(OllaComun o : listaOllas) { %>
                                            <option value="<%= o.getId() %>"><%= o.getNombreOlla() %></option>
                                        <% } %>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">Tipo de Recurso *</label>
                                    <select class="form-select bg-light" name="tipo_recurso" required>
                                        <option value="">-- Selecciona un tipo --</option>
                                        <option value="Alimentos">Alimentos</option>
                                        <option value="Medicinas">Medicinas</option>
                                        <option value="Utensilios">Utensilios de cocina</option>
                                    </select>
                                </div>

                                <div class="row">
                                    <div class="col-6 mb-3">
                                        <label class="form-label small fw-bold text-muted">Cantidad *</label>
                                        <input type="number" step="0.1" class="form-control bg-light" name="cantidad" required>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label class="form-label small fw-bold text-muted">Unidad *</label>
                                        <select class="form-select bg-light" name="unidad" required>
                                            <option value="kg">Kilogramos (kg)</option>
                                            <option value="litros">Litros (l)</option>
                                            <option value="unidades">Unidades</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label small fw-bold text-muted">Descripción (Opcional)</label>
                                    <textarea class="form-control bg-light" name="descripcion" rows="2" placeholder="Ej. Llevo 2 sacos de arroz costeño..."></textarea>
                                </div>

                                <button type="submit" class="btn btn-primary btn-lg w-100 rounded-pill fw-bold shadow-sm">
                                    <i class="bi bi-heart-fill me-2"></i> Enviar Donación
                                </button>
                            </form>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla de Transparencia (Donaciones Globales) -->
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold text-dark mb-0"><i class="bi bi-globe-americas text-success me-2"></i>Impacto Comunitario</h4>
                    <span class="badge bg-success rounded-pill px-3 py-2">Solo donaciones entregadas</span>
                </div>
                
                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-4">Donante</th>
                                        <th>Ayuda Entregada</th>
                                        <th>Destino</th>
                                        <th>Fecha</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (donacionesGlobales != null && !donacionesGlobales.isEmpty()) { 
                                        for(String[] fila : donacionesGlobales) { %>
                                        <tr>
                                            <td class="ps-4 fw-bold text-dark"><i class="bi bi-person-circle text-muted me-2"></i><%= fila[1] %></td>
                                            <td class="text-primary"><%= fila[3] %></td>
                                            <td><span class="badge bg-light text-dark border"><%= fila[2] %></span></td>
                                            <td class="text-muted small"><%= fila[0] %></td>
                                        </tr>
                                    <%  } 
                                       } else { %>
                                        <tr>
                                            <td colspan="4" class="text-center py-5 text-muted">
                                                Sé el primero en hacer una diferencia hoy.
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
