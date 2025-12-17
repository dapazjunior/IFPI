<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <title>Consulta de Venda</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class='container mt-4'>
    <h2>Consulta de Venda</h2>";

$id = limpar($_POST["id"]);

$comando = "SELECT v.*, ve.nome as vendedor_nome, c.nome as cliente_nome, p.descricao as produto_descricao
            FROM vendas v
            JOIN vendedores ve ON v.vendedor_matricula = ve.matricula
            JOIN clientes c ON v.cliente_cpf = c.cpf
            JOIN produtos p ON v.produto_codigo = p.codigo
            WHERE v.id = '$id'";
            
$resultado = mysqli_query($conexao, $comando);
$qtdeRegistros = mysqli_num_rows($resultado);

if ($qtdeRegistros == 0) {
    echo "<div class='alert alert-warning'>Nenhuma venda encontrada com o ID $id.</div>";
} else {
    $campo = mysqli_fetch_array($resultado);
    echo "<table class='table table-bordered'>";
    echo "<tr><th>ID da Venda:</th><td>" . htmlspecialchars($campo["id"]) . "</td></tr>";
    echo "<tr><th>Data e Hora:</th><td>" . date('d/m/Y H:i', strtotime($campo["data_hora"])) . "</td></tr>";
    echo "<tr><th>Vendedor:</th><td>" . htmlspecialchars($campo["vendedor_nome"]) . " (Matrícula: " . $campo["vendedor_matricula"] . ")</td></tr>";
    echo "<tr><th>Cliente:</th><td>" . htmlspecialchars($campo["cliente_nome"]) . " (CPF: " . $campo["cliente_cpf"] . ")</td></tr>";
    echo "<tr><th>Produto:</th><td>" . htmlspecialchars($campo["produto_descricao"]) . " (Código: " . $campo["produto_codigo"] . ")</td></tr>";
    echo "<tr><th>Quantidade:</th><td>" . $campo["quantidade"] . " unidades</td></tr>";
    echo "<tr><th>Valor Total:</th><td>R$ " . number_format($campo["valor_total"], 2, ',', '.') . "</td></tr>";
    
    // Calcular comissão (10%)
    $comissao = $campo["valor_total"] * 0.10;
    echo "<tr><th>Comissão do Vendedor (10%):</th><td>R$ " . number_format($comissao, 2, ',', '.') . "</td></tr>";
    
    echo "</table>";
}

echo "<p><a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a></p>";
echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>