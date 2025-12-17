<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <title>Inclusão de Produto</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class='container mt-4'>
    <h2>Inclusão de Produto</h2>";

$descricao = limpar($_POST["descricao"]);
$preco = limpar($_POST["preco"]);
$quantidade_estoque = limpar($_POST["quantidade_estoque"]);

$comando = "INSERT INTO produtos (descricao, preco, quantidade_estoque) 
            VALUES ('$descricao', '$preco', '$quantidade_estoque')";

if (mysqli_query($conexao, $comando)) {
    echo "<div class='alert alert-success'>Produto incluído com sucesso!</div>";
} else {
    echo "<div class='alert alert-danger'>Erro ao incluir produto: " . mysqli_error($conexao) . "</div>";
}

echo "<p><a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a></p>";
echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>