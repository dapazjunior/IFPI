<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <title>Listagem de Produtos</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class='container mt-4'>
    <h2>Listagem de Produtos</h2>";

$comando = "SELECT * FROM produtos ORDER BY descricao";
$resultado = mysqli_query($conexao, $comando);
$qtdeRegistros = mysqli_num_rows($resultado);

if ($qtdeRegistros == 0) {
    echo "<div class='alert alert-warning'>Nenhum produto cadastrado.</div>";
} else {
    echo "<p>Total: <strong>$qtdeRegistros</strong> produto(s) encontrado(s).</p>";
    
    echo "<table class='table table-bordered table-striped table-hover'>
            <thead class='table-dark'>
                <tr>
                    <th>Código</th>
                    <th>Descrição</th>
                    <th>Preço</th>
                    <th>Estoque</th>
                    <th>Valor Total em Estoque</th>
                </tr>
            </thead>
            <tbody>";
    
    $valor_total_estoque = 0;
    
    while ($campo = mysqli_fetch_array($resultado)) {
        $valor_item = $campo["preco"] * $campo["quantidade_estoque"];
        $valor_total_estoque += $valor_item;
        
        echo "<tr>";
        echo "<td>" . htmlspecialchars($campo["codigo"]) . "</td>";
        echo "<td>" . htmlspecialchars($campo["descricao"]) . "</td>";
        echo "<td>R$ " . number_format($campo["preco"], 2, ',', '.') . "</td>";
        echo "<td>" . $campo["quantidade_estoque"] . "</td>";
        echo "<td>R$ " . number_format($valor_item, 2, ',', '.') . "</td>";
        echo "</tr>";
    }
    
    echo "</tbody>
          <tfoot class='table-dark'>
            <tr>
                <td colspan='4'><strong>Valor Total em Estoque:</strong></td>
                <td><strong>R$ " . number_format($valor_total_estoque, 2, ',', '.') . "</strong></td>
            </tr>
          </tfoot>
          </table>";
}

echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>