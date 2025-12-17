<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <title>Alteração de Cliente</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class='container mt-4'>
    <h2>Alteração de Cliente</h2>";

$cpf = limpar($_POST["cpf"]);
$comando = "SELECT * FROM clientes WHERE cpf = '$cpf'";
$resultado = mysqli_query($conexao, $comando);
$qtdeRegistros = mysqli_num_rows($resultado);

if ($qtdeRegistros == 0) {
    echo "<div class='alert alert-warning'>Nenhum cliente encontrado com o CPF $cpf.</div>";
} else {
    $campo = mysqli_fetch_array($resultado);
    
    echo "<form method='post' action='clienteAlteracao_Confirmar.php'>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>CPF:</label>";
    echo "<input class='form-control' type='text' value='" . htmlspecialchars($campo["cpf"]) . "' readonly>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Nome (*):</label>";
    echo "<input class='form-control' type='text' name='nome' value='" . htmlspecialchars($campo["nome"]) . "' maxlength='100' required>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Identidade:</label>";
    echo "<input class='form-control' type='text' name='identidade' value='" . htmlspecialchars($campo["identidade"]) . "' maxlength='20'>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Endereço:</label>";
    echo "<input class='form-control' type='text' name='endereco' value='" . htmlspecialchars($campo["endereco"]) . "' maxlength='200'>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Telefone:</label>";
    echo "<input class='form-control' type='text' name='telefone' value='" . htmlspecialchars($campo["telefone"]) . "' maxlength='20'>";
    echo "</div>";
    
    echo "<input type='hidden' name='cpf' value='" . $campo["cpf"] . "'>";
    echo "<a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a> ";
    echo "<input class='btn btn-success' type='submit' name='confirmar' value='Confirmar Alteração'>";
    echo "</form>";
}

echo "<p><a href='../index.html' class='btn btn-info mt-3'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>