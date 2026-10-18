<%-- 
    Document   : perfil
    Created on : 16 oct. 2026, 1:47:12 p. m.
    Author     : FABRIZZIO
--%>

<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    if (usu == null) {
        response.sendRedirect("index.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil - Red Comunitaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body style="background-color: #f8f9fa;">

    <!-- Inyectamos la barra superior y el menú lateral -->
    <%@include file="includes/topbar.jsp" %>
    <%@include file="includes/sidebar.jsp" %>

    <!-- CONTENIDO PRINCIPAL DEL PERFIL -->
    <div class="container-fluid p-4">
        <h2 class="mb-4 fw-bold text-white">Mi Perfil</h2>
        
        <!-- Alertas de éxito o error -->
        <% if ("true".equals(request.getParameter("exito"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>¡Excelente!</strong> Tus datos han sido actualizados correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("true".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error:</strong> No se pudieron actualizar tus datos. Inténtalo más tarde.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4">
                <div class="mb-4">
                    <!-- BOTÓN MODIFICADO: Ahora abre el Modal -->
                    <button class="btn btn-info text-white fw-bold rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#modalEditarPerfil">
                        Editar Perfil
                    </button>
                </div>
                
                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">Email (No editable)</label>
                    <div class="form-control bg-light border-0"><%= usu.getEmail() %></div>
                </div>
                
                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">Nombres Completos</label>
                    <div class="form-control bg-light border-0"><%= usu.getNombres() %> <%= usu.getApellidos() %></div>
                </div>
                
                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">Rol en el Sistema</label>
                    <div class="form-control bg-light border-0 text-uppercase"><%= usu.getRol() %></div>
                </div>
                
                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">Teléfono</label>
                    <div class="form-control bg-light border-0"><%= usu.getTelefono() != null ? usu.getTelefono() : "No registrado" %></div>
                </div>
                
                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">DNI</label>
                    <div class="form-control bg-light border-0"><%= usu.getDni() %></div>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL DE EDICIÓN BOOTSTRAP -->
    <div class="modal fade" id="modalEditarPerfil" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-0 rounded-4 shadow-lg">
                <div class="modal-header bg-primary text-white" style="border-top-left-radius: 1rem; border-top-right-radius: 1rem;">
                    <h5 class="modal-title fw-bold" id="modalLabel">Actualizar Datos</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="UsuarioControlador" method="POST">
                    <div class="modal-body p-4">
                        <input type="hidden" name="accion" value="actualizarPerfil">
                        
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Nombres</label>
                            <input type="text" class="form-control" name="nombres" value="<%= usu.getNombres() %>" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Apellidos</label>
                            <input type="text" class="form-control" name="apellidos" value="<%= usu.getApellidos() %>" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Teléfono</label>
                            <input type="tel" class="form-control" name="telefono" value="<%= usu.getTelefono() != null ? usu.getTelefono() : "" %>">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">DNI</label>
                            <input type="text" class="form-control" name="dni" value="<%= usu.getDni() %>" maxlength="8" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
