<%-- 
    Document   : admin_solicitudes
    Created on : 16 oct. 2026, 7:02:28 p. m.
    Author     : FABRIZZIO
--%>

<%@page import="java.util.List"%>
<%@page import="modelo.Solicitud"%>
<%@page import="dao.OllaDAO"%>
<%@page import="modelo.Usuario"%>
<%@page import="dao.SolicitudDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // VALIDACIÓN: Solo el ADMIN entra aquí
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    if (usu == null || !usu.getRol().equalsIgnoreCase("ADMIN")) {
        response.sendRedirect("index.jsp");
        return; 
    }

    SolicitudDAO solDao = new SolicitudDAO(); // Usando el nuevo DAO
    List<Solicitud> todasLasSolicitudes = solDao.listarTodasLasSolicitudes();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aprobar Solicitudes - Red Comunitaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body style="background-color: #f8f9fa;">

    <%@include file="includes/topbar.jsp" %>
    <%@include file="includes/sidebar.jsp" %>

    <div class="container-fluid p-4">
        <h2 class="mb-4 fw-bold text-dark">
            <i class="bi bi-shield-check text-success me-2"></i> Gestión de Solicitudes Globales
        </h2>

        <% if ("true".equals(request.getParameter("exito"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                El estado de la solicitud ha sido actualizado.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4">
                <p class="text-muted">Como administrador, debes validar las solicitudes antes de que sean visibles para los donadores.</p>
                
                <div class="table-responsive mt-4">
                    <table class="table table-hover align-middle text-center">
                        <thead class="table-dark">
                            <tr>
                                <th>Olla Común</th>
                                <th>Insumo Pedido</th>
                                <th>Cantidad</th>
                                <th>Urgencia</th>
                                <th>Estado</th>
                                <th>Acciones (Aprobar/Rechazar)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (todasLasSolicitudes != null && !todasLasSolicitudes.isEmpty()) { 
                                for(Solicitud sol : todasLasSolicitudes) { %>
                                <tr>
                                    <td class="fw-bold text-primary"><%= sol.getNombreOlla() %></td>
                                    <td><%= sol.getRecursoNecesitado() %></td>
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
                                    <td>
                                        <% if(sol.getEstado().equals("Pendiente")) { %>
                                            <!-- Botón Aprobar -->
                                            <form action="OllaControlador" method="POST" class="d-inline">
                                                <input type="hidden" name="accion" value="cambiarEstadoSolicitud">
                                                <input type="hidden" name="idSolicitud" value="<%= sol.getId() %>">
                                                <input type="hidden" name="nuevoEstado" value="Aceptada">
                                                <button type="submit" class="btn btn-success btn-sm fw-bold"><i class="bi bi-check-lg"></i></button>
                                            </form>
                                            <!-- Botón Rechazar -->
                                            <form action="OllaControlador" method="POST" class="d-inline">
                                                <input type="hidden" name="accion" value="cambiarEstadoSolicitud">
                                                <input type="hidden" name="idSolicitud" value="<%= sol.getId() %>">
                                                <input type="hidden" name="nuevoEstado" value="Rechazada">
                                                <button type="submit" class="btn btn-danger btn-sm fw-bold"><i class="bi bi-x-lg"></i></button>
                                            </form>
                                        <% } else { %>
                                            <span class="text-muted small">Sin acciones</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <%  } 
                               } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">No hay solicitudes registradas en el sistema.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
