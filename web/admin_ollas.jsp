<%-- 
    Document   : admin_ollas
    Created on : 18 oct. 2026, 1:56:21 p. m.
    Author     : FABRIZZIO
--%>

<%@page import="java.util.List"%>
<%@page import="dao.OllaDAO"%>
<%@page import="modelo.OllaComun"%>
<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    if (usu == null || !usu.getRol().equalsIgnoreCase("ADMIN")) {
        response.sendRedirect("index.jsp");
        return; 
    }

    OllaDAO oDao = new OllaDAO();
    List<OllaComun> listaOllas = oDao.listarTodasAdmin();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Ollas - Red Comunitaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body style="background-color: #f8f9fa;">

    <%@include file="includes/topbar.jsp" %>
    <%@include file="includes/sidebar.jsp" %>

    <div class="container-fluid p-4">
        <h2 class="mb-4 fw-bold text-dark">
            <i class="bi bi-house-gear-fill text-primary me-2"></i> Gestión de Ollas Comunes
        </h2>

        <!-- Alertas -->
        <% if ("true".equals(request.getParameter("exito"))) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                Operación realizada con éxito.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <% if ("true".equals(request.getParameter("errorFk"))) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <strong>No se puede eliminar:</strong> Esta olla ya tiene donaciones, recursos o solicitudes registradas. Si ya no funciona, edítala y cambia su estado a "INACTIVA".
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>Nombre</th>
                                <th>Dirección</th>
                                <th>Beneficiarios</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(listaOllas != null && !listaOllas.isEmpty()) {
                                for(OllaComun o : listaOllas) { %>
                                <tr>
                                    <td class="fw-bold text-primary"><%= o.getNombreOlla() %></td>
                                    <td><%= o.getDireccion() %></td>
                                    <td><%= o.getBeneficiariosAtendidos() %></td>
                                    <td>
                                        <span class="badge <%= o.getEstado().equals("ACTIVA") ? "bg-success" : "bg-danger" %> rounded-pill px-3 py-1">
                                            <%= o.getEstado() %>
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <!-- Botón Editar -->
                                        <button type="button" class="btn btn-warning btn-sm fw-bold shadow-sm me-1" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#modalEditarOlla"
                                                data-id="<%= o.getId() %>"
                                                data-nombre="<%= o.getNombreOlla() %>"
                                                data-direccion="<%= o.getDireccion() %>"
                                                data-descripcion="<%= o.getDescripcion() %>"
                                                data-beneficiarios="<%= o.getBeneficiariosAtendidos() %>"
                                                data-estado="<%= o.getEstado() %>">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>

                                        <!-- Botón Eliminar -->
                                        <form action="OllaControlador" method="POST" class="d-inline" onsubmit="return confirm('¿Estás seguro de eliminar esta olla? Se perderá permanentemente si no tiene registros amarrados.');">
                                            <input type="hidden" name="accion" value="eliminarOllaAdmin">
                                            <input type="hidden" name="idOlla" value="<%= o.getId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm fw-bold shadow-sm">
                                                <i class="bi bi-trash-fill"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <%  } 
                               } else { %>
                                <tr><td colspan="5" class="text-center py-4 text-muted">No hay ollas registradas.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL DE EDICIÓN DE OLLA -->
    <div class="modal fade" id="modalEditarOlla" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header bg-primary text-white rounded-top-4">
                    <h5 class="modal-title fw-bold"><i class="bi bi-house-gear-fill me-2"></i>Editar Olla Común</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="OllaControlador" method="POST">
                    <div class="modal-body p-4">
                        <input type="hidden" name="accion" value="editarOllaAdmin">
                        <input type="hidden" name="idOlla" id="edit_id_olla">

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Nombre de la Olla</label>
                            <input type="text" class="form-control bg-light" name="nombre_olla" id="edit_nombre_olla" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Dirección</label>
                            <input type="text" class="form-control bg-light" name="direccion" id="edit_direccion" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Descripción</label>
                            <textarea class="form-control bg-light" name="descripcion" id="edit_descripcion" rows="2"></textarea>
                        </div>
                        <div class="row">
                            <div class="col-6">
                                <label class="form-label small fw-bold text-muted">Beneficiarios</label>
                                <input type="number" class="form-control bg-light" name="beneficiarios" id="edit_beneficiarios" min="0" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold text-muted">Estado</label>
                                <select class="form-select bg-light fw-bold" name="estado" id="edit_estado">
                                    <option value="ACTIVA">ACTIVA</option>
                                    <option value="INACTIVA">INACTIVA (Pausada)</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary px-4 fw-bold shadow-sm">Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Escuchamos cuando el modal está a punto de abrirse
        var modalEditarOlla = document.getElementById('modalEditarOlla');
        modalEditarOlla.addEventListener('show.bs.modal', function (event) {

            var button = event.relatedTarget;
            
            // Extraemos la información de los atributos data-* del botón
            var id = button.getAttribute('data-id');
            var nombre = button.getAttribute('data-nombre');
            var direccion = button.getAttribute('data-direccion');
            var descripcion = button.getAttribute('data-descripcion');
            var beneficiarios = button.getAttribute('data-beneficiarios');
            var estado = button.getAttribute('data-estado');
            
            // Inyectamos los datos en los inputs del formulario dentro del modal
            document.getElementById('edit_id_olla').value = id;
            document.getElementById('edit_nombre_olla').value = nombre;
            document.getElementById('edit_direccion').value = direccion;
            document.getElementById('edit_descripcion').value = descripcion !== 'null' ? descripcion : '';
            document.getElementById('edit_beneficiarios').value = beneficiarios;
            document.getElementById('edit_estado').value = estado;
        });
    </script>
</body>
</html>