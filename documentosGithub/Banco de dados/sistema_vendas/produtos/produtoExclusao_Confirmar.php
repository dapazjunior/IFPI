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

// Verificar se o produto tem vendas registradas
$comando_verifica = "SELECT COUNT(*) as total FROM vendas WHERE produto_codigo = '$codigo'";
$resultado_verifica = mysqli_query($conexao, $comando_verifica);
$verifica = mysqli_fetch_array($resultado_verifica);

if ($verifica['total'] > 0) {
    echo "<div class='alert alert-danger'>Não é possível excluir este produto pois existem vendas registradas para ele.</div>";
} else {
    $comando = "DELETE FROM produtos WHERE codigo = '$codigo'";
    $resultado = mysqli_query($conexao, $comando);
    
    if ($resultado) {
        echo "<div class='alert alert-success'>Produto excluído com sucesso!</div>";
    } else {
        echo "<div class='alert alert-danger'>Erro ao excluir produto: " . mysqli_error($conexao) . "</div>";
    }
}

echo "<p><a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a></p>";
echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>