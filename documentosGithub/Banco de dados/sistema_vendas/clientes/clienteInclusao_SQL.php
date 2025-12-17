<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <title>Inclusão de Cliente</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class='container mt-4'>
    <h2>Inclusão de Cliente</h2>";

$cpf = limpar($_POST["cpf"]);
$nome = limpar($_POST["nome"]);
$identidade = limpar($_POST["identidade"]);
$endereco = limpar($_POST["endereco"]);
$telefone = limpar($_POST["telefone"]);

$comando = "INSERT INTO clientes (cpf, nome, identidade, endereco, telefone) 
            VALUES ('$cpf', '$nome', '$identidade', '$endereco', '$telefone')";

if (mysqli_query($conexao, $comando)) {
    echo "<div class='alert alert-success'>Cliente incluído com sucesso!</div>";
} else {
    if (mysqli_errno($conexao) == 1062) {
        echo "<div class='alert alert-warning'>O CPF <b>$cpf</b> já está cadastrado.</div>";
    } else {
        echo "<div class='alert alert-danger'>Erro ao incluir cliente: " . mysqli_error($conexao) . "</div>";
    }
}

echo "<p><a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a></p>";
echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>