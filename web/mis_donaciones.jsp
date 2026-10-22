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
                ¡Operación realizada con éxito!
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
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (misDonaciones != null && !misDonaciones.isEmpty()) { 
                                for(String[] fila : misDonaciones) { %>
                                <tr>
                                    <td class="text-muted small"><%= fila[1] %></td>
                                    <td class="fw-bold text-primary"><%= fila[2] %></td>
                                    <td><%= fila[3] %></td>
                                    <td>
                                        <span class="badge <%= fila[4].equals("Pendiente") ? "bg-warning text-dark" : (fila[4].equals("Aceptada") ? "bg-success" : "bg-danger") %> rounded-pill px-3 py-2">
                                            <%= fila[4] %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (!fila[4].equals("Aceptada")) { %>
                                            <!-- Botón Editar -->
                                            <button type="button" class="btn btn-warning btn-sm fw-bold shadow-sm me-1" 
                                                onclick="abrirModalEditarDonacion('<%= fila[0] %>', '<%= fila[3] %>')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <!-- Botón Eliminar -->
                                            <form action="DonacionControlador" method="POST" class="d-inline" onsubmit="return confirm('¿Estás seguro de cancelar esta donación?');">
                                                <input type="hidden" name="accion" value="eliminarDonacion">
                                                <input type="hidden" name="idDonacion" value="<%= fila[0] %>">
                                                <button type="submit" class="btn btn-danger btn-sm fw-bold shadow-sm">
                                                    <i class="bi bi-trash-fill"></i>
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <!-- Mensaje visual de bloqueo -->
                                            <span class="badge bg-light text-muted border border-secondary px-3 py-2">
                                                <i class="bi bi-lock-fill me-1"></i> Bloqueada
                                            </span>
                                        <% } %>
                                    </td>
                                </tr>
                            <%  } 
                               } else { %>
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
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

    <!-- MODAL DE EDICIÓN DE DONACIÓN -->
    <div class="modal fade" id="modalEditarDonacion" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header bg-warning text-dark rounded-top-4">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>Editar Detalles de Donación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="DonacionControlador" method="POST">
                    <div class="modal-body p-4">
                        <input type="hidden" name="accion" value="actualizarDonacion">
                        <input type="hidden" name="idDonacion" id="edit_donacion_id">

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Detalle del Recurso (Mensaje)</label>
                            <textarea class="form-control bg-light" name="mensaje" id="edit_donacion_mensaje" rows="3" required></textarea>
                            <div class="form-text text-muted">Corrige las cantidades o la descripción de tu donación.</div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-warning px-4 fw-bold shadow-sm">Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function abrirModalEditarDonacion(id, mensaje) {
            document.getElementById('edit_donacion_id').value = id;
            document.getElementById('edit_donacion_mensaje').value = mensaje;
            var miModal = new bootstrap.Modal(document.getElementById('modalEditarDonacion'));
            miModal.show();
        }
    </script>
</body>
</html>