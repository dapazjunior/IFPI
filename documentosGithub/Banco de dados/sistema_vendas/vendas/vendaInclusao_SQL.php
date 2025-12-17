<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <title>Inclusão de Venda</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class='container mt-4'>
    <h2>Inclusão de Venda</h2>";

$data_hora = limpar($_POST["data_hora"]);
$vendedor_matricula = limpar($_POST["vendedor_matricula"]);
$cliente_cpf = limpar($_POST["cliente_cpf"]);
$produto_codigo = limpar($_POST["produto_codigo"]);
$quantidade = limpar($_POST["quantidade"]);
$valor_total = limpar($_POST["valor_total"]);

// Verificar se há estoque suficiente
$comando_estoque = "SELECT quantidade_estoque FROM produtos WHERE codigo = '$produto_codigo'";
$resultado_estoque = mysqli_query($conexao, $comando_estoque);
$estoque = mysqli_fetch_array($resultado_estoque);

if ($estoque['quantidade_estoque'] < $quantidade) {
    echo "<div class='alert alert-danger'>Estoque insuficiente! Disponível: " . $estoque['quantidade_estoque'] . " unidades</div>";
} else {
    // Inserir venda
    $comando = "INSERT INTO vendas (data_hora, vendedor_matricula, cliente_cpf, produto_codigo, quantidade, valor_total) 
                VALUES ('$data_hora', '$vendedor_matricula', '$cliente_cpf', '$produto_codigo', '$quantidade', '$valor_total')";
    
    if (mysqli_query($conexao, $comando)) {
        // Atualizar estoque do produto
        $novo_estoque = $estoque['quantidade_estoque'] - $quantidade;
        $comando_atualiza = "UPDATE produtos SET quantidade_estoque = '$novo_estoque' WHERE codigo = '$produto_codigo'";
        mysqli_query($conexao, $comando_atualiza);
        
        echo "<div class='alert alert-success'>Venda registrada com sucesso!</div>";
        echo "<p><strong>Resumo da Venda:</strong></p>";
        echo "<table class='table table-bordered'>";
        echo "<tr><th>Data/Hora:</th><td>" . date('d/m/Y H:i', strtotime($data_hora)) . "</td></tr>";
        echo "<tr><th>Quantidade:</th><td>" . $quantidade . "</td></tr>";
        echo "<tr><th>Valor Total:</th><td>R$ " . number_format($valor_total, 2, ',', '.') . "</td></tr>";
        echo "</table>";
    } else {
        echo "<div class='alert alert-danger'>Erro ao registrar venda: " . mysqli_error($conexao) . "</div>";
    }
}

echo "<p><a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a></p>";
echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>