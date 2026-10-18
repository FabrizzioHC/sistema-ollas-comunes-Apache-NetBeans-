<%-- 
    Document   : admin_donaciones
    Created on : 16 oct. 2026, 9:26:21 p. m.
    Author     : FABRIZZIO
--%>

<%@page import="java.util.List"%>
<%@page import="dao.DonacionDAO"%>
<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // VALIDACIÓN: Solo el ADMIN
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    if (usu == null || !usu.getRol().equalsIgnoreCase("ADMIN")) {
        response.sendRedirect("index.jsp");
        return; 
    }

    DonacionDAO dDao = new DonacionDAO();
    List<String[]> listaDonaciones = dDao.listarTodasLasDonacionesAdmin();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Aprobar Donaciones - Red Comunitaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body style="background-color: #f8f9fa;">

    <%@include file="includes/topbar.jsp" %>
    <%@include file="includes/sidebar.jsp" %>

    <div class="container-fluid p-4">
        <h2 class="mb-4 fw-bold text-dark">
            <i class="bi bi-box-seam text-success me-2"></i> Gestión de Donaciones
        </h2>

        <% if ("true".equals(request.getParameter("exito"))) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                El estado de la donación se ha actualizado correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4">
                <p class="text-muted">Revisa las intenciones de donación. Una vez aceptadas, se mostrarán públicamente en el panel de Impacto Comunitario.</p>
                
                <div class="table-responsive mt-4">
                    <table class="table table-hover align-middle text-center">
                        <thead class="table-dark">
                            <tr>
                                <th>Fecha</th>
                                <th>Donante</th>
                                <th>Destino (Olla)</th>
                                <th>Recurso Ofrecido</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (listaDonaciones != null && !listaDonaciones.isEmpty()) { 
                                for(String[] d : listaDonaciones) { %>
                                <tr>
                                    <td class="text-muted small"><%= d[1] %></td>
                                    <td class="fw-bold"><i class="bi bi-person-fill text-muted me-1"></i> <%= d[2] %></td>
                                    <td class="text-primary fw-medium"><%= d[3] %></td>
                                    <td><%= d[4] %></td>
                                    <td>
                                        <span class="badge <%= d[5].equals("Pendiente") ? "bg-warning text-dark" : (d[5].equals("Aceptada") ? "bg-success" : "bg-danger") %> rounded-pill px-3 py-2">
                                            <%= d[5] %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if(d[5].equals("Pendiente")) { %>
                                            <!-- Botón Aprobar -->
                                            <form action="DonacionControlador" method="POST" class="d-inline">
                                                <input type="hidden" name="accion" value="cambiarEstadoDonacion">
                                                <input type="hidden" name="idDonacion" value="<%= d[0] %>">
                                                <input type="hidden" name="nuevoEstado" value="Aceptada">
                                                <button type="submit" class="btn btn-success btn-sm fw-bold shadow-sm" title="Aprobar"><i class="bi bi-check-lg"></i></button>
                                            </form>
                                            <!-- Botón Rechazar -->
                                            <form action="DonacionControlador" method="POST" class="d-inline">
                                                <input type="hidden" name="accion" value="cambiarEstadoDonacion">
                                                <input type="hidden" name="idDonacion" value="<%= d[0] %>">
                                                <input type="hidden" name="nuevoEstado" value="Rechazada">
                                                <button type="submit" class="btn btn-danger btn-sm fw-bold shadow-sm" title="Rechazar"><i class="bi bi-x-lg"></i></button>
                                            </form>
                                        <% } else { %>
                                            <span class="text-muted small"><i class="bi bi-dash-lg"></i></span>
                                        <% } %>
                                    </td>
                                </tr>
                            <%  } 
                               } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">No hay donaciones registradas en el sistema.</td>
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
