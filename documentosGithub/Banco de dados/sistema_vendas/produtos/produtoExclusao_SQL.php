<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <title>Exclusão de Produto</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class='container mt-4'>
    <h2>Exclusão de Produto</h2>";

$codigo = limpar($_POST["codigo"]);
$comando = "SELECT * FROM produtos WHERE codigo = '$codigo'";
$resultado = mysqli_query($conexao, $comando);
$qtdeRegistros = mysqli_num_rows($resultado);

if ($qtdeRegistros == 0) {
    echo "<div class='alert alert-warning'>Nenhum produto encontrado com o código $codigo.</div>";
} else {
    $campo = mysqli_fetch_array($resultado);
    
    echo "<p>Confirma a exclusão do produto abaixo?</p>";
    echo "<table class='table table-bordered'>";
    echo "<tr><th>Código:</th><td>" . htmlspecialchars($campo["codigo"]) . "</td></tr>";
    echo "<tr><th>Descrição:</th><td>" . htmlspecialchars($campo["descricao"]) . "</td></tr>";
    echo "<tr><th>Preço:</th><td>R$ " . number_format($campo["preco"], 2, ',', '.') . "</td></tr>";
    echo "</table>";
    
    echo "<form method='post' action='produtoExclusao_Confirmar.php'>";
    echo "<input type='hidden' name='codigo' value='" . $campo["codigo"] . "'>";
    echo "<input class='btn btn-danger' type='submit' name='confirmar' value='Confirmar Exclusão'>";
    echo "</form>";
}

echo "<p><a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a></p>";
echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>