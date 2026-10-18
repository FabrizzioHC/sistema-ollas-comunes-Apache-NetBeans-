<%-- 
    Document   : gestion_recursos
    Created on : 16 oct. 2026, 6:07:27 p. m.
    Author     : FABRIZZIO
--%>

<%@page import="java.util.List"%>
<%@page import="modelo.Recurso"%>
<%@page import="modelo.OllaComun"%>
<%@page import="dao.OllaDAO"%>
<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // VALIDACIÓN ESTRICTA: Solo Lideresas pueden ver esta página
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    if (usu == null || !usu.getRol().equalsIgnoreCase("LIDERESA")) {
        response.sendRedirect("index.jsp");
        return; 
    }

    // Consultamos a la BD la información de la olla y su inventario
    OllaDAO ollaDao = new OllaDAO();
    OllaComun miOlla = ollaDao.obtenerOllaPorLideresaId(usu.getId());
    List<Recurso> inventario = null;
    
    if(miOlla != null){
        inventario = ollaDao.listarRecursosPorOlla(miOlla.getId());
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Recursos - Red Comunitaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body style="background-color: #f8f9fa;">

    <!-- Inyectamos nuestra plantilla (Menú y Barra superior) -->
    <%@include file="includes/topbar.jsp" %>
    <%@include file="includes/sidebar.jsp" %>

    <div class="container-fluid p-4">
        <h2 class="mb-4 fw-bold text-dark">
            <i class="bi bi-box-seam-fill text-brown me-2"></i> Inventario de 
            <span class="text-primary text-white"><%= miOlla != null ? miOlla.getNombreOlla() : "Mi Olla" %></span>
        </h2>

        <!-- Alertas de éxito o error -->
        <% if ("true".equals(request.getParameter("exito"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Recurso agregado correctamente al inventario.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- COLUMNA IZQUIERDA: Formulario para agregar recurso -->
            <div class="col-lg-4">
                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-header bg-white border-0 pt-4 pb-0 px-4">
                        <h5 class="fw-bold mb-0">Registrar Ingreso</h5>
                    </div>
                    <div class="card-body p-4">
                        <form action="OllaControlador" method="POST">
                            <input type="hidden" name="accion" value="agregarRecurso">
                            
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
                                + Agregar al Inventario
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- COLUMNA DERECHA: Tabla de inventario actual -->
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 rounded-4 h-100">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-4">Stock Actual</h5>
                        
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Recurso</th>
                                        <th>Cantidad</th>
                                        <th>Unidad</th>
                                        <th>Última Actualización</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (inventario != null && !inventario.isEmpty()) { 
                                        for(Recurso rec : inventario) { %>
                                        <tr>
                                            <td class="fw-medium"><%= rec.getNombreRecurso() %></td>
                                            <td><span class="badge bg-primary rounded-pill px-3 py-2"><%= rec.getCantidad() %></span></td>
                                            <td class="text-muted"><%= rec.getUnidadMedida() %></td>
                                            <td class="text-muted small"><%= rec.getFechaActualizacion() %></td>
                                        </tr>
                                    <%  } 
                                       } else { %>
                                        <tr>
                                            <td colspan="4" class="text-center py-4 text-muted">
                                                Aún no tienes recursos registrados en tu inventario.
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
