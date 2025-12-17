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
$nome = limpar($_POST["nome"]);
$identidade = limpar($_POST["identidade"]);
$endereco = limpar($_POST["endereco"]);
$telefone = limpar($_POST["telefone"]);

$comando = "UPDATE clientes SET 
            nome = '$nome',
            identidade = '$identidade',
            endereco = '$endereco',
            telefone = '$telefone'
            WHERE cpf = '$cpf'";

$resultado = mysqli_query($conexao, $comando);

if ($resultado) {
    echo "<div class='alert alert-success'>Cliente alterado com sucesso!</div>";
} else {
    echo "<div class='alert alert-danger'>Erro ao alterar cliente: " . mysqli_error($conexao) . "</div>";
}

echo "<p><a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a></p>";
echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>