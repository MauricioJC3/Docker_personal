<?php
require __DIR__ . '/vendor/autoload.php';

use Dompdf\Dompdf;

// Crear instancia de Dompdf
$dompdf = new Dompdf();

// HTML que quieres convertir a PDF
$html = "
<h1>Hola, esto es un PDF de prueba</h1>
<p>Generado con Dompdf en Docker</p>
<ul>
    <li>Proyecto 1</li>
    <li>".date('Y-m-d')."</li>
</ul>
";

// Cargar HTML
$dompdf->loadHtml($html);

// Renderizar PDF
$dompdf->render();

// Descargar automáticamente (o usar ->stream() para previsualizar)
$dompdf->stream("documento.pdf", [
    "Attachment" => true
]);