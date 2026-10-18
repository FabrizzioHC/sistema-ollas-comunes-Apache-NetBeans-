<%@page import="java.util.List"%>
<%@page import="dao.DonacionDAO"%>
<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    if (usu == null || !usu.getRol().equalsIgnoreCase("DONADOR")) {
        response.sendRedirect("index.jsp");
        return; 
    }
    DonacionDAO dDao = new DonacionDAO();
    List<String[]> misDonaciones = dDao.listarMisDonaciones(usu.getId());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi Historial de Donaciones - Red Comunitaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <%@include file="includes/topbar.jsp" %>
    <%@include file="includes/sidebar.jsp" %>

    <div class="container-fluid p-4">
        <h2 class="mb-4 fw-bold text-dark">
            <i class="bi bi-clock-history text-primary me-2"></i> Mi Historial de Donaciones
        </h2>

        <% if ("true".equals(request.getParameter("exito"))) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                ¡Gracias por tu donación! Ha sido registrada y la lideresa la revisará pronto.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4">
                <p class="text-muted mb-4">Aquí puedes hacer seguimiento al estado de todas las ayudas que has brindado a las ollas comunes.</p>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Fecha</th>
                                <th>Destino (Olla Común)</th>
                                <th>Detalle del Recurso</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (misDonaciones != null && !misDonaciones.isEmpty()) { 
                                for(String[] fila : misDonaciones) { %>
                                <tr>
                                    <td class="text-muted small"><%= fila[0] %></td>
                                    <td class="fw-bold text-primary"><%= fila[1] %></td>
                                    <td><%= fila[2] %></td>
                                    <td>
                                        <span class="badge <%= fila[3].equals("Pendiente") ? "bg-warning text-dark" : (fila[3].equals("Aceptada") ? "bg-success" : "bg-danger") %> rounded-pill px-3 py-2">
                                            <%= fila[3] %>
                                        </span>
                                    </td>
                                </tr>
                            <%  } 
                               } else { %>
                                <tr>
                                    <td colspan="4" class="text-center py-5 text-muted">
                                        Aún no has registrado ninguna donación. ¡Ve a "Donar Ahora" en el inicio para empezar!
                                    </td>
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