<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <title>Listagem de Clientes</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class='container mt-4'>
    <h2>Listagem de Clientes</h2>";

$comando = "SELECT * FROM clientes ORDER BY nome";
$resultado = mysqli_query($conexao, $comando);
$qtdeRegistros = mysqli_num_rows($resultado);

if ($qtdeRegistros == 0) {
    echo "<div class='alert alert-warning'>Nenhum cliente cadastrado.</div>";
} else {
    echo "<p>Total: <strong>$qtdeRegistros</strong> cliente(s) encontrado(s).</p>";
    
    echo "<table class='table table-bordered table-striped table-hover'>
            <thead class='table-dark'>
                <tr>
                    <th>CPF</th>
                    <th>Nome</th>
                    <th>Identidade</th>
                    <th>Endereço</th>
                    <th>Telefone</th>
                </tr>
            </thead>
            <tbody>";
    
    while ($campo = mysqli_fetch_array($resultado)) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($campo["cpf"]) . "</td>";
        echo "<td>" . htmlspecialchars($campo["nome"]) . "</td>";
        echo "<td>" . htmlspecialchars($campo["identidade"]) . "</td>";
        echo "<td>" . htmlspecialchars($campo["endereco"]) . "</td>";
        echo "<td>" . htmlspecialchars($campo["telefone"]) . "</td>";
        echo "</tr>";
    }
    
    echo "</tbody></table>";
}

echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>