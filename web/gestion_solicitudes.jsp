<%-- 
    Document   : solicitudes
    Created on : 16 oct. 2026, 6:49:09 p. m.
    Author     : FABRIZZIO
--%>

<%@page import="java.util.List"%>
<%@page import="modelo.Solicitud"%>
<%@page import="modelo.OllaComun"%>
<%@page import="dao.OllaDAO"%>
<%@page import="dao.SolicitudDAO"%>
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
        SolicitudDAO solDao = new SolicitudDAO();
        misSolicitudes = solDao.listarPorOlla(miOlla.getId());
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
                Operación realizada correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- COLUMNA IZQUIERDA: Formulario de Creación -->
            <div class="col-lg-4">
                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-header bg-white border-0 pt-4 pb-0 px-4">
                        <h5 class="fw-bold mb-0">Pedir Insumos</h5>
                    </div>
                    <div class="card-body p-4">
                        <form action="SolicitudControlador" method="POST">
                            <input type="hidden" name="accion" value="crearSolicitud">
                            <% if(miOlla != null) { %>
                                <input type="hidden" name="idOlla" value="<%= miOlla.getId() %>">
                            <% } %>
                            
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

            <!-- COLUMNA DERECHA: Tabla de estado (Listar, Editar, Eliminar) -->
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
                                        <th>Acciones</th>
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
                                                <td>
                                                    <% if (!sol.getEstado().equalsIgnoreCase("Aceptada")) { %>
                                                        <!-- Botón Editar (Solo aparece si el estado NO es Aceptada) -->
                                                        <button type="button" class="btn btn-warning btn-sm fw-bold shadow-sm me-1" 
                                                            onclick="abrirModalEditar('<%= sol.getId() %>', '<%= sol.getRecursoNecesitado() %>', '<%= sol.getCantidadNecesitada() %>', '<%= sol.getUnidadMedida() %>', '<%= sol.getNivelUrgencia() %>')">
                                                            <i class="bi bi-pencil-square"></i>
                                                        </button>
                                                        <!-- Botón Eliminar (Solo aparece si el estado NO es Aceptada) -->
                                                        <form action="SolicitudControlador" method="POST" class="d-inline" onsubmit="return confirm('¿Estás seguro de eliminar esta solicitud?');">
                                                            <input type="hidden" name="accion" value="eliminarSolicitud">
                                                            <input type="hidden" name="idSolicitud" value="<%= sol.getId() %>">
                                                            <button type="submit" class="btn btn-danger btn-sm fw-bold shadow-sm">
                                                                <i class="bi bi-trash-fill"></i>
                                                            </button>
                                                        </form>
                                                    <% } else { %>
                                                        <!-- Mensaje visual cuando está bloqueada -->
                                                        <span class="badge bg-light text-muted border border-secondary px-3 py-2">
                                                            <i class="bi bi-lock-fill me-1"></i> Bloqueada
                                                        </span>
                                                    <% } %>
                                                </td>
                                        </tr>
                                    <%  } 
                                       } else { %>
                                        <tr>
                                            <td colspan="6" class="text-center py-4 text-muted">
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

    <!-- MODAL DE EDICIÓN -->
    <div class="modal fade" id="modalEditarSolicitud" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header bg-warning text-dark rounded-top-4">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>Editar Solicitud</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="SolicitudControlador" method="POST">
                    <div class="modal-body p-4">
                        <input type="hidden" name="accion" value="actualizarSolicitud">
                        <input type="hidden" name="idSolicitud" id="edit_id">

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Insumo Necesitado</label>
                            <input type="text" class="form-control bg-light" name="recursoNecesitado" id="edit_recurso" required>
                        </div>
                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="form-label small fw-bold text-muted">Cantidad</label>
                                <input type="number" step="0.01" class="form-control bg-light" name="cantidad" id="edit_cantidad" required>
                            </div>
                            <div class="col-6 mb-3">
                                <label class="form-label small fw-bold text-muted">Unidad</label>
                                <select class="form-select bg-light" name="unidadMedida" id="edit_unidad">
                                    <option value="kg">kg</option>
                                    <option value="litros">Litros</option>
                                    <option value="unidades">Unidades</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Nivel de Urgencia</label>
                            <select class="form-select bg-light" name="nivelUrgencia" id="edit_urgencia">
                                <option value="Normal">Normal</option>
                                <option value="Alta">Alta</option>
                                <option value="Crítica">Crítica</option>
                            </select>
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
        function abrirModalEditar(id, recurso, cantidad, unidad, urgencia) {
            document.getElementById('edit_id').value = id;
            document.getElementById('edit_recurso').value = recurso;
            document.getElementById('edit_cantidad').value = cantidad;
            document.getElementById('edit_unidad').value = unidad;
            document.getElementById('edit_urgencia').value = urgencia;
            
            var miModal = new bootstrap.Modal(document.getElementById('modalEditarSolicitud'));
            miModal.show();
        }
    </script>
</body>
</html>