<%-- 
    Document   : admin_recursos
    Created on : 22 oct 2026, 11:36:46
    Author     : USER
--%>

<%@page import="java.util.List"%>
<%@page import="modelo.Recurso"%>
<%@page import="dao.RecursoDAO"%>
<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // VALIDACIÓN ESTRICTA: Solo Administradores
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    if (usu == null || !usu.getRol().equalsIgnoreCase("ADMIN")) {
        response.sendRedirect("login.jsp");
        return; 
    }

    RecursoDAO recursoDao = new RecursoDAO();
    // Lista todos los recursos que pertenezcan al almacén general (olla_id IS NULL o = 0)
    List<Recurso> stockGeneral = recursoDao.listarAlmacenGeneral();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Almacén General - Administrador</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body style="background-color: #f8f9fa;">

    <%@include file="includes/topbar.jsp" %>
    <%@include file="includes/sidebar.jsp" %>

    <div class="container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold text-dark">
                <i class="bi bi-building-fill-gear text-primary me-2"></i> Almacén Central de Donaciones
            </h2>
            <span class="badge bg-danger fs-6 px-3 py-2">Rol: Administrador</span>
        </div>

        <% if ("true".equals(request.getParameter("exito"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Operación realizada correctamente en el almacén central.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- Formulario de Ingreso Central -->
            <div class="col-lg-4">
                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-header bg-white border-0 pt-4 pb-0 px-4">
                        <h5 class="fw-bold mb-0">Ingreso Manual al Almacén</h5>
                        <p class="text-muted small">Registra donaciones físicas recibidas centralmente</p>
                    </div>
                    <div class="card-body p-4">
                        <form action="RecursoControlador" method="POST">
                            <input type="hidden" name="accion" value="registrarAlmacenGeneral">
                            
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Nombre del Recurso</label>
                                <input type="text" class="form-control bg-light" name="nombreRecurso" placeholder="Ej. Arroz, Aceite, Fideos" required>
                            </div>
                            
                            <div class="row">
                                <div class="col-6 mb-3">
                                    <label class="form-label small fw-bold text-muted">Cantidad</label>
                                    <input type="number" step="0.01" class="form-control bg-light" name="cantidad" placeholder="0.00" required>
                                </div>
                                <div class="col-6 mb-3">
                                    <label class="form-label small fw-bold text-muted">Unidad</label>
                                    <select class="form-select bg-light" name="unidadMedida" required>
                                        <option value="kg">Kilogramos (kg)</option>
                                        <option value="litros">Litros (L)</option>
                                        <option value="unidades">Unidades (uds)</option>
                                        <option value="sacos">Sacos</option>
                                    </select>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-primary w-100 rounded-pill fw-bold mt-2">
                                + Guardar en Almacén
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Tabla de Stock Central -->
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 rounded-4 h-100">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-4">Stock Disponible para Distribuir</h5>
                        
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Recurso</th>
                                        <th>Stock Total</th>
                                        <th>Unidad</th>
                                        <th>Última Actualización</th>
                                        <th class="text-center">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (stockGeneral != null && !stockGeneral.isEmpty()) { 
                                        for(Recurso rec : stockGeneral) { %>
                                        <tr>
                                            <td><%= rec.getId() %></td>
                                            <td class="fw-medium"><%= rec.getNombreRecurso() %></td>
                                            <td><span class="badge bg-success rounded-pill px-3 py-2 fs-6"><%= rec.getCantidad() %></span></td>
                                            <td class="text-muted"><%= rec.getUnidadMedida() %></td>
                                            <td class="text-muted small"><%= rec.getFechaActualizacion() %></td>
                                            <td class="text-center">
                                                <!-- Botón Editar -->
                                                <button type="button" class="btn btn-sm btn-outline-warning me-1" data-bs-toggle="modal" data-bs-target="#modalEdit<%= rec.getId() %>">
                                                    <i class="bi bi-pencil-fill"></i>
                                                </button>
                                                <!-- Formulario Eliminar -->
                                                <form action="RecursoControlador" method="POST" class="d-inline" onsubmit="return confirm('¿Seguro que deseas dar de baja este insumo del almacén?');">
                                                    <input type="hidden" name="accion" value="eliminarAlmacenGeneral">
                                                    <input type="hidden" name="idRecurso" value="<%= rec.getId() %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                                        <i class="bi bi-trash-fill"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>

                                        <!-- Modal Editar -->
                                        <div class="modal fade" id="modalEdit<%= rec.getId() %>" tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <form action="RecursoControlador" method="POST">
                                                        <input type="hidden" name="accion" value="editarAlmacenGeneral">
                                                        <input type="hidden" name="idRecurso" value="<%= rec.getId() %>">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title fw-bold">Actualizar Stock</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="mb-3">
                                                                <label class="form-label small fw-bold">Nombre</label>
                                                                <input type="text" class="form-control" name="nombreRecurso" value="<%= rec.getNombreRecurso() %>" required>
                                                            </div>
                                                            <div class="row">
                                                                <div class="col-6 mb-3">
                                                                    <label class="form-label small fw-bold">Cantidad</label>
                                                                    <input type="number" step="0.01" class="form-control" name="cantidad" value="<%= rec.getCantidad() %>" required>
                                                                </div>
                                                                <div class="col-6 mb-3">
                                                                    <label class="form-label small fw-bold">Unidad</label>
                                                                    <select class="form-select" name="unidadMedida" required>
                                                                        <option value="kg" <%= "kg".equalsIgnoreCase(rec.getUnidadMedida()) ? "selected" : "" %>>Kilogramos (kg)</option>
                                                                        <option value="litros" <%= "litros".equalsIgnoreCase(rec.getUnidadMedida()) ? "selected" : "" %>>Litros (L)</option>
                                                                        <option value="unidades" <%= "unidades".equalsIgnoreCase(rec.getUnidadMedida()) ? "selected" : "" %>>Unidades (uds)</option>
                                                                        <option value="sacos" <%= "sacos".equalsIgnoreCase(rec.getUnidadMedida()) ? "selected" : "" %>>Sacos</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                            <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    <%  } 
                                       } else { %>
                                        <tr>
                                            <td colspan="6" class="text-center py-4 text-muted">
                                                No hay insumos almacenados actualmente en el almacén central.
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