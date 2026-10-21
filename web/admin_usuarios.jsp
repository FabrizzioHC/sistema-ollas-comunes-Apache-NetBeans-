<%-- 
    Document   : admin_usuarios
    Created on : 16 oct. 2026, 9:35:16 p. m.
    Author     : FABRIZZIO
--%>

<%@page import="java.util.List"%>
<%@page import="dao.UsuarioDAO"%>
<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    if (usu == null || !usu.getRol().equalsIgnoreCase("ADMIN")) {
        response.sendRedirect("index.jsp");
        return; 
    }

    UsuarioDAO uDao = new UsuarioDAO();
    List<Usuario> listaUsuarios = uDao.listarTodos();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Usuarios - Red Comunitaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body style="background-color: #f8f9fa;">

    <%@include file="includes/topbar.jsp" %>
    <%@include file="includes/sidebar.jsp" %>

    <div class="container-fluid p-4">
        <h2 class="mb-4 fw-bold text-dark">
            <i class="bi bi-people-fill text-primary me-2"></i> Gestión de Usuarios
        </h2>

        <% if ("true".equals(request.getParameter("exito"))) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                Datos del usuario actualizados correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>Nombres</th>
                                <th>Apellidos</th>
                                <th>Correo / Email</th>
                                <th>DNI</th>
                                <th>Rol</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(listaUsuarios != null) {
                                for(Usuario u : listaUsuarios) { %>
                                <tr>
                                    <td class="fw-medium"><%= u.getNombres() %></td>
                                    <td><%= u.getApellidos() %></td>
                                    <td><%= u.getEmail() %></td>
                                    <td><%= u.getDni() %></td>
                                    <td>
                                        <span class="badge <%= u.getRol().equals("ADMIN") ? "bg-danger" : (u.getRol().equals("LIDERESA") ? "bg-info text-dark" : "bg-primary") %> rounded-pill px-3 py-1">
                                            <%= u.getRol() %>
                                        </span>
                                    </td>
                                    <td>
                                        <!-- Botón que activa la función JavaScript pasando los datos -->
                                        <button class="btn btn-warning btn-sm fw-bold shadow-sm" 
                                            onclick="abrirModalEditar('<%= u.getId() %>', '<%= u.getNombres() %>', '<%= u.getApellidos() %>', '<%= u.getEmail() %>', '<%= u.getTelefono() %>', '<%= u.getDni() %>', '<%= u.getRol() %>')">
                                            <i class="bi bi-pencil-square"></i> Editar
                                        </button>
                                            <!--Eliminar-->
                                        <form action="UsuarioControlador" method="POST" class="d-inline" onsubmit="return confirm('¿Estás seguro de eliminar este usuario? Se perderá permanentemente si no tiene registros amarrados.');">
                                            <input type="hidden" name="accion" value="eliminarUsuarioAdmin">
                                            <input type="hidden" name="idUsu" value="<%= u.getId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm fw-bold shadow-sm" title="Eliminar">
                                                <i class="bi bi-trash-fill"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <%  } 
                               } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL DE EDICIÓN -->
    <div class="modal fade" id="modalEditarUsuario" tabindex="-1" aria-labelledby="modalEditarLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header bg-primary text-white rounded-top-4">
                    <h5 class="modal-title fw-bold" id="modalEditarLabel"><i class="bi bi-person-lines-fill me-2"></i>Editar Usuario</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="UsuarioControlador" method="POST">
                    <div class="modal-body p-4">
                        <input type="hidden" name="accion" value="editarUsuarioAdmin">
                        <input type="hidden" name="idUsuario" id="edit_id">

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Nombres</label>
                                <input type="text" class="form-control bg-light" name="nombres" id="edit_nombres" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Apellidos</label>
                                <input type="text" class="form-control bg-light" name="apellidos" id="edit_apellidos" required>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold text-muted">Email</label>
                                <input type="email" class="form-control bg-light" name="email" id="edit_email" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">DNI</label>
                                <input type="text" class="form-control bg-light" name="dni" id="edit_dni" maxlength="8">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Teléfono</label>
                                <input type="text" class="form-control bg-light" name="telefono" id="edit_telefono">
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold text-muted">Rol de Usuario</label>
                                <select class="form-select bg-light fw-bold" name="rol" id="edit_rol">
                                    <option value="DONADOR">DONADOR</option>
                                    <option value="LIDERESA">LIDERESA</option>
                                    <option value="ADMIN">ADMIN</option>
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
        // Función para inyectar los datos en el Modal antes de mostrarlo
        function abrirModalEditar(id, nombres, apellidos, email, telefono, dni, rol) {
            document.getElementById('edit_id').value = id;
            document.getElementById('edit_nombres').value = nombres;
            document.getElementById('edit_apellidos').value = apellidos;
            document.getElementById('edit_email').value = email;
            document.getElementById('edit_telefono').value = telefono !== 'null' ? telefono : '';
            document.getElementById('edit_dni').value = dni !== 'null' ? dni : '';
            document.getElementById('edit_rol').value = rol;
            
            var miModal = new bootstrap.Modal(document.getElementById('modalEditarUsuario'));
            miModal.show();
        }
    </script>
</body>
</html>
