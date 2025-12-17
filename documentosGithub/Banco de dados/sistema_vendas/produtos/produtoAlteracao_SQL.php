<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <title>Alteração de Produto</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class='container mt-4'>
    <h2>Alteração de Produto</h2>";

$codigo = limpar($_POST["codigo"]);
$comando = "SELECT * FROM produtos WHERE codigo = '$codigo'";
$resultado = mysqli_query($conexao, $comando);
$qtdeRegistros = mysqli_num_rows($resultado);

if ($qtdeRegistros == 0) {
    echo "<div class='alert alert-warning'>Nenhum produto encontrado com o código $codigo.</div>";
} else {
    $campo = mysqli_fetch_array($resultado);
    
    echo "<form method='post' action='produtoAlteracao_Confirmar.php'>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Código:</label>";
    echo "<input class='form-control' type='text' value='" . htmlspecialchars($campo["codigo"]) . "' readonly>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Descrição (*):</label>";
    echo "<input class='form-control' type='text' name='descricao' value='" . htmlspecialchars($campo["descricao"]) . "' maxlength='200' required>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Preço (*):</label>";
    echo "<input class='form-control' type='number' step='0.01' name='preco' value='" . $campo["preco"] . "' required>";
    echo "</div>";
    
    echo "<div class='mb-3'>";
    echo "<label class='form-label'>Quantidade em Estoque (*):</label>";
    echo "<input class='form-control' type='number' name='quantidade_estoque' value='" . $campo["quantidade_estoque"] . "' required>";
    echo "</div>";
    
    echo "<input type='hidden' name='codigo' value='" . $campo["codigo"] . "'>";
    echo "<a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a> ";
    echo "<input class='btn btn-success' type='submit' name='confirmar' value='Confirmar Alteração'>";
    echo "</form>";
}

echo "<p><a href='../index.html' class='btn btn-info mt-3'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>