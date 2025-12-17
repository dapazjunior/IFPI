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
$nome = limpar($_POST["nome"]);
$endereco = limpar($_POST["endereco"]);
$telefone = limpar($_POST["telefone"]);
$salario_base = limpar($_POST["salario_base"]);
$comissao = limpar($_POST["comissao"]);

$comando = "UPDATE vendedores SET 
            nome = '$nome',
            endereco = '$endereco',
            telefone = '$telefone',
            salario_base = '$salario_base',
            comissao = '$comissao'
            WHERE matricula = '$matricula'";

$resultado = mysqli_query($conexao, $comando);

if ($resultado) {
    echo "<div class='alert alert-success'>Vendedor alterado com sucesso!</div>";
} else {
    echo "<div class='alert alert-danger'>Erro ao alterar vendedor: " . mysqli_error($conexao) . "</div>";
}

echo "<p><a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a></p>";
echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>