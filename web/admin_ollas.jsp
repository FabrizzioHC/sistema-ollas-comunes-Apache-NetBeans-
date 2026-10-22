<%-- 
    Document   : admin_ollas
    Created on : 18 oct. 2026, 1:56:21 p. m.
    Author     : FABRIZZIO
--%>

<%@page import="java.util.List"%>
<%@page import="dao.OllaDAO"%>
<%@page import="modelo.OllaComun"%>
<%@page import="modelo.Usuario"%>
<%!
    private String escaparHtmlOlla(String valor) {
        if (valor == null) return "";
        return valor.replace("&", "&amp;").replace("<", "&lt;")
                    .replace(">", "&gt;").replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usu = (Usuario) session.getAttribute("usuarioLogueado");
    if (usu == null || !usu.getRol().equalsIgnoreCase("ADMIN")) {
        response.sendRedirect("index.jsp");
        return; 
    }
    // Los datos llegan del controlador, nunca se consulta el DAO desde el JSP.
    if (request.getAttribute("listaOllas") == null) {
        String parametros = request.getQueryString();
        response.sendRedirect("OllaControlador" + (parametros == null ? "" : "?" + parametros));
        return;
    }

   List<OllaComun> listaOllas = (List<OllaComun>) request.getAttribute("listaOllas");
    List<Usuario> lideresasDisponibles = (List<Usuario>) request.getAttribute("lideresasDisponibles");
    String terminoBusqueda = (String) request.getAttribute("terminoBusqueda");
    if (terminoBusqueda == null) terminoBusqueda = "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Ollas - Red Comunitaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        /* Evita que el margen global .form-control desalineé el buscador */
        #panelBuscarOlla .input-group > .form-control {
            margin-bottom: 0;
            border-radius: 0;
            padding: .375rem .75rem;
        }
        #panelBuscarOlla .input-group > .input-group-text {
            border-radius: .375rem 0 0 .375rem;
        }
        #panelBuscarOlla .input-group > .btn {
            border-radius: 0 .375rem .375rem 0;
        }
    </style>
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

        <% if ("true".equals(request.getParameter("agregado"))) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                Olla común agregada correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
        <% } %>
        <% if ("true".equals(request.getParameter("errorAgregar"))) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                No se pudo agregar la olla. Verifica los datos y que la lideresa seleccionada esté disponible.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
        <% } %>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-4">
                <!-- Acciones dentro del cuadro blanco -->
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-3">
                    <span class="fw-semibold text-secondary">Ollas comunes registradas</span>
                    <div class="d-flex flex-wrap gap-2">
                        <button type="button" class="btn btn-outline-primary fw-bold shadow-sm" id="btnBuscarOlla"
                                aria-expanded="<%= !terminoBusqueda.isEmpty() %>" aria-controls="panelBuscarOlla">
                            <i class="bi bi-search me-1"></i> Buscar
                        </button>
                        <button type="button" class="btn btn-success fw-bold shadow-sm"
                                data-bs-toggle="modal" data-bs-target="#modalAgregarOlla">
                            <i class="bi bi-plus-circle me-1"></i> Agregar
                        </button>
                    </div>
                </div>

                <!-- Búsqueda real: GET -> Controlador -> DAO -> MySQL -->
                <div id="panelBuscarOlla" class="<%= terminoBusqueda.isEmpty() ? "d-none " : "" %>mb-3">
                    <form action="OllaControlador" method="GET">
                        <input type="hidden" name="accion" value="buscarOllaAdmin">
                        <label for="inputBuscarOlla" class="form-label fw-bold">Buscar olla común</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="search" class="form-control" id="inputBuscarOlla" name="q"
                                   value="<%= escaparHtmlOlla(terminoBusqueda) %>"
                                   placeholder="Nombre, dirección, beneficiarios o estado" autocomplete="off">
                            <button type="submit" class="btn btn-primary">Buscar</button>
                            <a href="OllaControlador" class="btn btn-outline-secondary">Limpiar</a>
                        </div>
                    </form>
                </div>
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
                                <tr class="fila-olla">
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
                                <tr><td colspan="5" class="text-center py-4 text-muted"><%= terminoBusqueda.isEmpty() ? "No hay ollas registradas." : "No se encontraron ollas con esa búsqueda." %></td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL AGREGAR OLLA COMÚN -->
    <div class="modal fade" id="modalAgregarOlla" tabindex="-1" aria-labelledby="modalAgregarOllaLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header bg-success text-white rounded-top-4">
                    <h5 class="modal-title fw-bold" id="modalAgregarOllaLabel">
                        <i class="bi bi-house-add-fill me-2"></i> Agregar Olla Común
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <form action="OllaControlador" method="POST" id="formAgregarOlla">
                    <input type="hidden" name="accion" value="agregarOllaAdmin">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label for="nuevaLideresa" class="form-label small fw-bold text-muted">Lideresa responsable</label>
                            <select class="form-select" name="usuario_id" id="nuevaLideresa" required>
                                <option value="" selected disabled>Selecciona una lideresa disponible</option>
                                <% for (Usuario lideresa : lideresasDisponibles) { %>
                                    <option value="<%= lideresa.getId() %>">
                                        <%= escaparHtmlOlla(lideresa.getNombres()) %> <%= escaparHtmlOlla(lideresa.getApellidos()) %>
                                        — <%= escaparHtmlOlla(lideresa.getEmail()) %>
                                    </option>
                                <% } %>
                            </select>
                            <div class="form-text">Cada lideresa puede gestionar una olla común.</div>
                        </div>
                        <% if (lideresasDisponibles.isEmpty()) { %>
                            <div class="alert alert-warning small">
                                No hay lideresas disponibles. Primero registra una usuaria con rol LIDERESA
                                desde Gestión de Usuarios.
                            </div>
                        <% } %>
                        <div class="mb-3">
                            <label for="nuevoNombreOlla" class="form-label small fw-bold text-muted">Nombre de la olla</label>
                            <input type="text" class="form-control" id="nuevoNombreOlla" name="nombre_olla"
                                   maxlength="150" required>
                        </div>
                        <div class="mb-3">
                            <label for="nuevaDireccionOlla" class="form-label small fw-bold text-muted">Dirección</label>
                            <input type="text" class="form-control" id="nuevaDireccionOlla" name="direccion"
                                   maxlength="255" required>
                        </div>
                        <div class="mb-3">
                            <label for="nuevaDescripcionOlla" class="form-label small fw-bold text-muted">Descripción (opcional)</label>
                            <textarea class="form-control" id="nuevaDescripcionOlla" name="descripcion" rows="2" maxlength="2000"></textarea>
                        </div>
                        <div class="row g-3">
                            <div class="col-6">
                                <label for="nuevosBeneficiarios" class="form-label small fw-bold text-muted">Beneficiarios</label>
                                <input type="number" class="form-control" id="nuevosBeneficiarios" name="beneficiarios"
                                       value="0" min="0" max="1000000" required>
                            </div>
                            <div class="col-6">
                                <label for="nuevoEstadoOlla" class="form-label small fw-bold text-muted">Estado</label>
                                <select class="form-select" id="nuevoEstadoOlla" name="estado" required>
                                    <option value="ACTIVA">ACTIVA</option>
                                    <option value="PAUSADA">PAUSADA</option>
                                    <option value="INACTIVA">INACTIVA</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold shadow-sm" <%= lideresasDisponibles.isEmpty() ? "disabled" : "" %>>
                            <i class="bi bi-check-lg me-1"></i> Guardar Olla
                        </button>
                    </div>
                </form>
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

        // Mostrar u ocultar el formulario; los datos se consultan en el servidor.
        var btnBuscarOlla = document.getElementById('btnBuscarOlla');
        var panelBuscarOlla = document.getElementById('panelBuscarOlla');
        btnBuscarOlla.addEventListener('click', function() {
            var abrir = panelBuscarOlla.classList.contains('d-none');
            panelBuscarOlla.classList.toggle('d-none', !abrir);
            btnBuscarOlla.setAttribute('aria-expanded', String(abrir));
            if (abrir) document.getElementById('inputBuscarOlla').focus();
        });
    </script>
</body>
</html>