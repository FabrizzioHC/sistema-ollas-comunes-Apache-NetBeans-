<%-- 
    Document   : admin_usuarios
    Created on : 16 oct. 2026, 9:35:16 p. m.
    Author     : JUAN
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
    <style>
    
    #panelBuscarUsuario .input-group > .form-control {
        margin-bottom: 0;
        padding: 0.375rem 0.75rem;
        border-radius: 0;
    }

    #panelBuscarUsuario .input-group > .input-group-text {
        border-radius: 0.375rem 0 0 0.375rem;
    }

    #panelBuscarUsuario .input-group > .btn {
        border-radius: 0 0.375rem 0.375rem 0;
    }
</style>
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


        <% if ("true".equals(request.getParameter("agregado"))) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                Usuario registrado correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
        <% } %>
        <% if ("true".equals(request.getParameter("errorAgregar"))) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                No se pudo agregar el usuario. Comprueba los datos y que el correo o DNI no estén registrados.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
        <% } %>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4">
           
                <div class="d-flex flex-wrap justify-content-end align-items-center gap-2 mb-3">
                    <button type="button" id="btnBuscarUsuario" class="btn btn-outline-primary fw-bold"
                            aria-controls="panelBuscarUsuario" aria-expanded="false">
                        <i class="bi bi-search me-1"></i> Buscar
                    </button>
                    <button type="button" class="btn btn-success fw-bold"
                            data-bs-toggle="modal" data-bs-target="#modalAgregarUsuario">
                        <i class="bi bi-person-plus-fill me-1"></i> Agregar
                    </button>
                </div>
                <!-- NUEVO: entrada de búsqueda (solo filtra filas existentes) -->
                <div id="panelBuscarUsuario" class="d-none mb-3">
                    <label for="inputBuscarUsuario" class="form-label fw-bold">Buscar usuario</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                        <input type="search" class="form-control" id="inputBuscarUsuario"
                               placeholder="Nombre, apellido, correo, DNI o rol" autocomplete="off">
                        <button type="button" id="btnLimpiarBusqueda" class="btn btn-outline-secondary">Limpiar</button>
                    </div>
                    <div id="contadorUsuarios" class="form-text mt-1" aria-live="polite"></div>
                </div>
                <div id="sinResultadosBusqueda" class="alert alert-light border d-none" role="status">
                    No se encontraron usuarios con esa búsqueda.
                </div>
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

    
    <div class="modal fade" id="modalAgregarUsuario" tabindex="-1" aria-labelledby="modalAgregarLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header bg-success text-white rounded-top-4">
                    <h5 class="modal-title fw-bold" id="modalAgregarLabel">
                        <i class="bi bi-person-plus-fill me-2"></i>Agregar Usuario
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <form action="UsuarioControlador" method="POST" id="formAgregarUsuario">
                    <input type="hidden" name="accion" value="agregarUsuarioAdmin">
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="nuevoNombres" class="form-label small fw-bold">Nombres</label>
                                <input type="text" name="nombres" id="nuevoNombres" class="form-control" maxlength="100" required>
                            </div>
                            <div class="col-md-6">
                                <label for="nuevoApellidos" class="form-label small fw-bold">Apellidos</label>
                                <input type="text" name="apellidos" id="nuevoApellidos" class="form-control" maxlength="100" required>
                            </div>
                            <div class="col-12">
                                <label for="nuevoEmail" class="form-label small fw-bold">Correo electrónico</label>
                                <input type="email" name="email" id="nuevoEmail" class="form-control" maxlength="100" required>
                            </div>
                            <div class="col-md-6">
                                <label for="nuevoDni" class="form-label small fw-bold">DNI</label>
                                <input type="text" name="dni" id="nuevoDni" class="form-control" minlength="8" maxlength="8"
                                       pattern="[0-9]{8}" inputmode="numeric" title="Ingresa 8 dígitos" required>
                            </div>
                            <div class="col-md-6">
                                <label for="nuevoTelefono" class="form-label small fw-bold">Teléfono (opcional)</label>
                                <input type="tel" name="telefono" id="nuevoTelefono" class="form-control" maxlength="20">
                            </div>
                            <div class="col-12">
                                <label for="nuevoRol" class="form-label small fw-bold">Rol</label>
                                <select name="rol" id="nuevoRol" class="form-select" required>
                                    <option value="" selected disabled>Selecciona un rol</option>
                                    <option value="DONADOR">DONADOR</option>
                                    <option value="LIDERESA">LIDERESA</option>
                                    <option value="ADMIN">ADMIN</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="nuevoPassword" class="form-label small fw-bold">Contraseña</label>
                                <input type="password" name="password" id="nuevoPassword" class="form-control"
                                       minlength="6" maxlength="255" autocomplete="new-password" required>
                            </div>
                            <div class="col-md-6">
                                <label for="confirmarPassword" class="form-label small fw-bold">Confirmar contraseña</label>
                                <input type="password" name="confirmarPassword" id="confirmarPassword" class="form-control"
                                       minlength="6" maxlength="255" autocomplete="new-password" required>
                            </div>
                        </div>
                        <div id="errorPassword" class="text-danger small mt-2 d-none">Las contraseñas no coinciden.</div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold px-4 shadow-sm">
                            <i class="bi bi-check-lg me-1"></i> Guardar Usuario
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

   
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


       
        const btnBuscarUsuario = document.getElementById('btnBuscarUsuario');
        const panelBuscarUsuario = document.getElementById('panelBuscarUsuario');
        const inputBuscarUsuario = document.getElementById('inputBuscarUsuario');
        const filasUsuarios = Array.from(document.querySelectorAll('.card .table-responsive tbody tr'));

        function normalizarBusqueda(valor) {
            return String(valor || '').toLocaleLowerCase('es').normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '');
        }

        function filtrarUsuarios() {
            const buscar = normalizarBusqueda(inputBuscarUsuario.value.trim());
            let visibles = 0;
            filasUsuarios.forEach(function(fila) {
                const datos = Array.from(fila.cells).slice(0, 5)
                    .map(function(celda) { return celda.textContent; }).join(' ');
                const mostrar = normalizarBusqueda(datos).includes(buscar);
                fila.style.display = mostrar ? '' : 'none';
                if (mostrar) visibles++;
            });
            document.getElementById('sinResultadosBusqueda').classList.toggle('d-none', visibles !== 0);
            document.getElementById('contadorUsuarios').textContent =
                visibles + (visibles === 1 ? ' usuario encontrado' : ' usuarios encontrados');
        }

        btnBuscarUsuario.addEventListener('click', function() {
            const abrir = panelBuscarUsuario.classList.contains('d-none');
            panelBuscarUsuario.classList.toggle('d-none', !abrir);
            btnBuscarUsuario.setAttribute('aria-expanded', String(abrir));
            if (abrir) {
                inputBuscarUsuario.focus();
            } else {
                inputBuscarUsuario.value = '';
            }
            filtrarUsuarios();
        });
        inputBuscarUsuario.addEventListener('input', filtrarUsuarios);
        document.getElementById('btnLimpiarBusqueda').addEventListener('click', function() {
            inputBuscarUsuario.value = '';
            filtrarUsuarios();
            inputBuscarUsuario.focus();
        });

        
        document.getElementById('formAgregarUsuario').addEventListener('submit', function(evento) {
            const password = document.getElementById('nuevoPassword').value;
            const confirmacion = document.getElementById('confirmarPassword').value;
            const error = document.getElementById('errorPassword');
            error.classList.toggle('d-none', password === confirmacion);
            if (password !== confirmacion) {
                evento.preventDefault();
                document.getElementById('confirmarPassword').focus();
            }
        });
    </script>
</body>
</html>
