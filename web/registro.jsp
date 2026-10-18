<%-- 
    Document   : registro
    Created on : 16 oct. 2026, 10:44:19 a. m.
    Author     : FABRIZZIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Cuenta - Sistema de Ollas Comunes</title>
    <!-- CSS de Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Iconos de Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <!-- Nuestro CSS Global -->
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

    <!-- BARRA SUPERIOR -->
    <nav class="navbar navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center" href="index.jsp">
                <i class="bi bi-suit-heart-fill text-danger me-2"></i> RedComunitaria
            </a>
            <div>
                <a href="index.jsp" class="btn-outline-light-custom">Iniciar Sesión</a>
            </div>
        </div>
    </nav>

    <!-- ÁREA CENTRAL CON EL FORMULARIO DE REGISTRO -->
    <div class="login-container my-4">
        <!-- Hacemos la tarjeta un poco más ancha (max-width: 600px) para acomodar más campos -->
        <div class="login-card" style="max-width: 600px;">
            
            <h4 class="fw-bold mb-2">Únete a RedComunitaria</h4>
            <p class="text-muted small mb-4">Completa tus datos para crear una cuenta.</p>

            <!-- FORMULARIO CONECTADO AL BACKEND -->
            <form action="UsuarioControlador" method="POST" id="formRegistro">
                <!-- Input oculto para el Servlet -->
                <input type="hidden" name="accion" value="registrar">
                
                <!-- Selector de Rol -->
                <div class="mb-4 text-start">
                    <label class="form-label text-muted small fw-bold">¿Cómo deseas participar?</label>
                    <div class="btn-group w-100" role="group">
                        <input type="radio" class="btn-check" name="rol" id="roleDonador" value="DONADOR" checked onchange="toggleCamposOlla()">
                        <label class="btn btn-outline-primary" for="roleDonador">Donador</label>

                        <input type="radio" class="btn-check" name="rol" id="roleOlla" value="LIDERESA" onchange="toggleCamposOlla()">
                        <label class="btn btn-outline-primary" for="roleOlla">Lideresa (Olla Común)</label>
                    </div>
                </div>

                <!-- Datos Personales (Comunes para ambos roles) -->
                <div class="row text-start">
                    <div class="col-md-6 mb-3">
                        <label class="form-label small">Nombres</label>
                        <input type="text" class="form-control" name="nombres" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label small">Apellidos</label>
                        <input type="text" class="form-control" name="apellidos" required>
                    </div>
                </div>

                <div class="row text-start">
                    <div class="col-md-6 mb-3">
                        <label class="form-label small">DNI</label>
                        <input type="text" class="form-control" name="dni" maxlength="8" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label small">Teléfono</label>
                        <input type="tel" class="form-control" name="telefono">
                    </div>
                </div>

                <!-- SECCIÓN DINÁMICA: Solo aparece si selecciona "Lideresa" -->
                <div id="camposOllaComun" style="display: none; background-color: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 15px;" class="text-start border">
                    <h6 class="fw-bold text-primary mb-3">Datos de la Olla Común</h6>
                    <div class="mb-3">
                        <label class="form-label small">Nombre de la Organización</label>
                        <input type="text" class="form-control" name="nombreOlla" id="inputNombreOlla">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small">Dirección Exacta</label>
                        <input type="text" class="form-control" name="direccionOlla" id="inputDireccionOlla">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small">Breve Descripción</label>
                        <textarea class="form-control" name="descripcionOlla" rows="2"></textarea>
                    </div>
                </div>

                <!-- Credenciales -->
                <div class="mb-3 text-start">
                    <label class="form-label small">Correo electrónico</label>
                    <input type="email" class="form-control" name="email" required>
                </div>
                
                <div class="row text-start mb-4">
                    <div class="col-md-6 mb-3 mb-md-0">
                        <label class="form-label small">Contraseña</label>
                        <input type="password" class="form-control" name="password" id="pass1" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small">Confirmar Contraseña</label>
                        <input type="password" class="form-control" id="pass2" required>
                        <small id="errorPass" class="text-danger fw-bold" style="display: none;">
                            Las contraseñas no coinciden.
                        </small>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary-custom">Registrarse</button>
            </form>

            <div class="mt-4 small">
                ¿Ya tienes cuenta? <a href="index.jsp" class="text-decoration-none">Inicia sesión aquí</a>
            </div>
        </div>
    </div>

    <!-- Scripts de Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Script para mostrar/ocultar los campos de la Olla Común -->
    <script>
        function toggleCamposOlla() {
            var isOlla = document.getElementById("roleOlla").checked;
            var divCamposOlla = document.getElementById("camposOllaComun");
            var inputNombre = document.getElementById("inputNombreOlla");
            var inputDireccion = document.getElementById("inputDireccionOlla");

            if (isOlla) {
                divCamposOlla.style.display = "block";
                // Hacemos que estos campos sean obligatorios solo si es lideresa
                inputNombre.required = true;
                inputDireccion.required = true;
            } else {
                divCamposOlla.style.display = "none";
                // Quitamos la obligatoriedad si es donador
                inputNombre.required = false;
                inputDireccion.required = false;
            }
        }
        
        // Capturamos el formulario para validarlo antes de que viaje a Java
        document.getElementById("formRegistro").addEventListener("submit", function(evento) {
            var p1 = document.getElementById("pass1").value;
            var p2 = document.getElementById("pass2").value;
            var mensajeError = document.getElementById("errorPass");

            // Si no son exactamente iguales, detenemos el envío
            if (p1 !== p2) {
                evento.preventDefault(); // Corta la comunicación con el Servlet
                mensajeError.style.display = "block"; // Muestra la alerta roja
            } else {
                mensajeError.style.display = "none";
            }
        });
    </script>
</body>
</html>
