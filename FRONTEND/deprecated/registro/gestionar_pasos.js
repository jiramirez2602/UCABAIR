let pasoActual = 1;

function mostrarPaso(paso) {
  const secciones = document.querySelectorAll('.pasos');
  secciones.forEach((seccion) => {
    seccion.style.display = 'none';
  });

  const pasoAmostrar = document.getElementById(`paso_${paso}`);
  if (pasoAmostrar) {
    pasoAmostrar.style.display = 'block';
  }
}

mostrarPaso(pasoActual);

function siguientePaso(event) {
  if (event) {
    event.preventDefault();
  }
  pasoActual++;
  mostrarPaso(pasoActual);
}

function pasoAnterior() {
  if (pasoActual > 1) {
    pasoActual--;
    mostrarPaso(pasoActual);
  }
}
