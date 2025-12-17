<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <title>Alteração de Vendedor</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class='container mt-4'>
    <h2>Alteração de Vendedor</h2>";

$matricula = limpar($_POST["matricula"]);
$comando = "SELECT * FROM vendedores WHERE matricula = '$matricula'";
$resultado = mysqli_query($conexao, $comando);
$qtdeRegistros = mysqli_num_rows($resultado);

if ($qtdeRegistros == 0) {
    echo "<div class='alert alert-warning'>Nenhum vendedor encontrado com a matrícula $matricula.</div>";
} else {
    $campo = mysqli_fetch_array($resultado);
    
    echo "<form method='post' action='vendedorAlteracao_Confirmar.php'>";
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Matrícula:</label>";
    echo "<input class='form-control' type='text' value='" . htmlspecialchars($campo["matricula"]) . "' readonly>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Nome (*):</label>";
    echo "<input class='form-control' type='text' name='nome' value='" . htmlspecialchars($campo["nome"]) . "' maxlength='100' required>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Endereço:</label>";
    echo "<input class='form-control' type='text' name='endereco' value='" . htmlspecialchars($campo["endereco"]) . "' maxlength='200'>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Telefone:</label>";
    echo "<input class='form-control' type='text' name='telefone' value='" . htmlspecialchars($campo["telefone"]) . "' maxlength='20'>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>CPF:</label>";
    echo "<input class='form-control' type='text' value='" . htmlspecialchars($campo["cpf"]) . "' readonly>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Salário Base (*):</label>";
    echo "<input class='form-control' type='number' step='0.01' name='salario_base' value='" . $campo["salario_base"] . "' required>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Comissão (%):</label>";
    echo "<input class='form-control' type='number' step='0.01' name='comissao' value='" . $campo["comissao"] . "'>";
    echo "</div>";
    
    echo "<input type='hidden' name='matricula' value='" . $campo["matricula"] . "'>";
    echo "<a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a> ";
    echo "<input class='btn btn-success' type='submit' name='confirmar' value='Confirmar Alteração'>";
    echo "</form>";
}

echo "<p><a href='../index.html' class='btn btn-info mt-3'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>