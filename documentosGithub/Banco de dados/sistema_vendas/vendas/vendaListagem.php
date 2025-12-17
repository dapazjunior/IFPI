<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <title>Listagem de Vendas</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class='container mt-4'>
    <h2>Listagem de Vendas</h2>";

$comando = "SELECT v.*, ve.nome as vendedor_nome, c.nome as cliente_nome, p.descricao as produto_descricao
            FROM vendas v
            JOIN vendedores ve ON v.vendedor_matricula = ve.matricula
            JOIN clientes c ON v.cliente_cpf = c.cpf
            JOIN produtos p ON v.produto_codigo = p.codigo
            ORDER BY v.data_hora DESC";
            
$resultado = mysqli_query($conexao, $comando);
$qtdeRegistros = mysqli_num_rows($resultado);

if ($qtdeRegistros == 0) {
    echo "<div class='alert alert-warning'>Nenhuma venda registrada.</div>";
} else {
    echo "<p>Total: <strong>$qtdeRegistros</strong> venda(s) encontrada(s).</p>";
    
    echo "<table class='table table-bordered table-striped table-hover'>
            <thead class='table-dark'>
                <tr>
                    <th>ID</th>
                    <th>Data/Hora</th>
                    <th>Vendedor</th>
                    <th>Cliente</th>
                    <th>Produto</th>
                    <th>Quantidade</th>
                    <th>Valor Total</th>
                    <th>Comissão</th>
                </tr>
            </thead>
            <tbody>";
    
    $valor_total_vendas = 0;
    $comissao_total = 0;
    
    while ($campo = mysqli_fetch_array($resultado)) {
        $comissao = $campo["valor_total"] * 0.10;
        $valor_total_vendas += $campo["valor_total"];
        $comissao_total += $comissao;
        
        echo "<tr>";
        echo "<td>" . htmlspecialchars($campo["id"]) . "</td>";
        echo "<td>" . date('d/m/Y H:i', strtotime($campo["data_hora"])) . "</td>";
        echo "<td>" . htmlspecialchars($campo["vendedor_nome"]) . "</td>";
        echo "<td>" . htmlspecialchars($campo["cliente_nome"]) . "</td>";
        echo "<td>" . htmlspecialchars($campo["produto_descricao"]) . "</td>";
        echo "<td>" . $campo["quantidade"] . "</td>";
        echo "<td>R$ " . number_format($campo["valor_total"], 2, ',', '.') . "</td>";
        echo "<td>R$ " . number_format($comissao, 2, ',', '.') . "</td>";
        echo "</tr>";
    }
    
    echo "</tbody>
          <tfoot class='table-dark'>
            <tr>
                <td colspan='6'><strong>TOTAIS:</strong></td>
                <td><strong>R$ " . number_format($valor_total_vendas, 2, ',', '.') . "</strong></td>
                <td><strong>R$ " . number_format($comissao_total, 2, ',', '.') . "</strong></td>
            </tr>
          </tfoot>
          </table>";
}

echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div></body></html>";

mysqli_close($conexao);
?>