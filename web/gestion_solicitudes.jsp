<%-- 
    Document   : solicitudes
    Created on : 16 oct. 2026, 6:49:09 p. m.
    Author     : FABRIZZIO
--%>

<%@page import="java.util.List"%>
<%@page import="modelo.Solicitud"%>
<%@page import="modelo.OllaComun"%>
<%@page import="dao.OllaDAO"%>
<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    if (usu == null || !usu.getRol().equalsIgnoreCase("LIDERESA")) {
        response.sendRedirect("index.jsp");
        return; 
    }

    OllaDAO ollaDao = new OllaDAO();
    OllaComun miOlla = ollaDao.obtenerOllaPorLideresaId(usu.getId());
    List<Solicitud> misSolicitudes = null;
    
    if(miOlla != null){
        misSolicitudes = ollaDao.listarSolicitudesPorOlla(miOlla.getId());
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solicitudes de Ayuda - Red Comunitaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body style="background-color: #f8f9fa;">

    <%@include file="includes/topbar.jsp" %>
    <%@include file="includes/sidebar.jsp" %>

    <div class="container-fluid p-4">
        <h2 class="mb-4 fw-bold text-dark">
            <i class="bi bi-megaphone-fill text-danger me-2"></i> Mis Solicitudes de Ayuda
        </h2>

        <% if ("true".equals(request.getParameter("exito"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Tu solicitud ha sido enviada y está en revisión.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- COLUMNA IZQUIERDA: Formulario -->
            <div class="col-lg-4">
                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-header bg-white border-0 pt-4 pb-0 px-4">
                        <h5 class="fw-bold mb-0">Pedir Insumos</h5>
                    </div>
                    <div class="card-body p-4">
                        <form action="OllaControlador" method="POST">
                            <input type="hidden" name="accion" value="agregarSolicitud">
                            
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">¿Qué necesitas?</label>
                                <input type="text" class="form-control bg-light" name="recursoNecesitado" placeholder="Ej. Agua potable, Fideos" required>
                            </div>
                            
                            <div class="row">
                                <div class="col-6 mb-3">
                                    <label class="form-label small fw-bold text-muted">Cantidad</label>
                                    <input type="number" step="0.01" class="form-control bg-light" name="cantidad" required>
                                </div>
                                <div class="col-6 mb-3">
                                    <label class="form-label small fw-bold text-muted">Unidad</label>
                                    <select class="form-select bg-light" name="unidadMedida" required>
                                        <option value="kg">kg</option>
                                        <option value="litros">Litros</option>
                                        <option value="unidades">Unidades</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label small fw-bold text-muted">Nivel de Urgencia</label>
                                <select class="form-select bg-light" name="nivelUrgencia" required>
                                    <option value="Normal">Normal</option>
                                    <option value="Alta">Alta (Pocos días de stock)</option>
                                    <option value="Crítica">Crítica (Sin insumos)</option>
                                </select>
                            </div>
                            
                            <button type="submit" class="btn btn-danger w-100 rounded-pill fw-bold">
                                <i class="bi bi-send-fill me-1"></i> Enviar Solicitud
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- COLUMNA DERECHA: Tabla de estado -->
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 rounded-4 h-100">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-4">Historial de Solicitudes</h5>
                        
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Insumo Pedido</th>
                                        <th>Cantidad</th>
                                        <th>Urgencia</th>
                                        <th>Estado</th>
                                        <th>Fecha</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (misSolicitudes != null && !misSolicitudes.isEmpty()) { 
                                        for(Solicitud sol : misSolicitudes) { %>
                                        <tr>
                                            <td class="fw-medium"><%= sol.getRecursoNecesitado() %></td>
                                            <td><%= sol.getCantidadNecesitada() %> <%= sol.getUnidadMedida() %></td>
                                            <td>
                                                <span class="badge <%= sol.getNivelUrgencia().equals("Crítica") ? "bg-danger" : (sol.getNivelUrgencia().equals("Alta") ? "bg-warning text-dark" : "bg-info text-dark") %>">
                                                    <%= sol.getNivelUrgencia() %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge <%= sol.getEstado().equals("Pendiente") ? "bg-warning text-dark" : (sol.getEstado().equals("Aceptada") ? "bg-success" : "bg-secondary") %> rounded-pill px-3 py-2">
                                                    <%= sol.getEstado() %>
                                                </span>
                                            </td>
                                            <td class="text-muted small"><%= sol.getFechaSolicitud() %></td>
                                        </tr>
                                    <%  } 
                                       } else { %>
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">
                                                No tienes solicitudes activas.
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
