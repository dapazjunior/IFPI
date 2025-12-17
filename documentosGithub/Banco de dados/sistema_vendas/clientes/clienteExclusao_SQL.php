<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <title>Exclusão de Cliente</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class='container mt-4'>
    <h2>Exclusão de Cliente</h2>";

$cpf = limpar($_POST["cpf"]);
$comando = "SELECT * FROM clientes WHERE cpf = '$cpf'";
$resultado = mysqli_query($conexao, $comando);
$qtdeRegistros = mysqli_num_rows($resultado);

if ($qtdeRegistros == 0) {
    echo "<div class='alert alert-warning'>Nenhum cliente encontrado com o CPF $cpf.</div>";
} else {
    $campo = mysqli_fetch_array($resultado);
    
    echo "<p>Confirma a exclusão do cliente abaixo?</p>";
    echo "<table class='table table-bordered'>";
    echo "<tr><th>CPF:</th><td>" . htmlspecialchars($campo["cpf"]) . "</td></tr>";
    echo "<tr><th>Nome:</th><td>" . htmlspecialchars($campo["nome"]) . "</td></tr>";
    echo "<tr><th>Telefone:</th><td>" . htmlspecialchars($campo["telefone"]) . "</td></tr>";
    echo "</table>";
    
    echo "<form method='post' action='clienteExclusao_Confirmar.php'>";
    echo "<input type='hidden' name='cpf' value='" . $campo["cpf"] . "'>";
    echo "<input class='btn btn-danger' type='submit' name='confirmar' value='Confirmar Exclusão'>";
    echo "</form>";
}

echo "<p><a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a></p>";
echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>