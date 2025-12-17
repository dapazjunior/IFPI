<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

// Buscar vendedores, clientes e produtos para os selects
$vendedores = mysqli_query($conexao, "SELECT matricula, nome FROM vendedores ORDER BY nome");
$clientes = mysqli_query($conexao, "SELECT cpf, nome FROM clientes ORDER BY nome");
$produtos = mysqli_query($conexao, "SELECT codigo, descricao, preco, quantidade_estoque FROM produtos ORDER BY descricao");

mysqli_close($conexao);
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Inclusão de Venda</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
    function calcularTotal() {
        var quantidade = document.getElementById('quantidade').value;
        var precoUnitario = document.getElementById('preco_unitario').value;
        
        if (quantidade && precoUnitario) {
            var total = quantidade * precoUnitario;
            document.getElementById('valor_total').value = total.toFixed(2);
            document.getElementById('valor_total_display').innerText = 'R$ ' + total.toFixed(2).replace('.', ',');
        }
    }
    
    function atualizarPreco() {
        var produtoCodigo = document.getElementById('produto_codigo').value;
        var precoUnitarioInput = document.getElementById('preco_unitario');
        var estoqueSpan = document.getElementById('estoque_atual');
        
        // Buscar preço e estoque do produto selecionado
        <?php
        $produtos_array = array();
        while ($prod = mysqli_fetch_assoc($produtos)) {
            $produtos_array[] = $prod;
        }
        echo "var produtos = " . json_encode($produtos_array) . ";\n";
        ?>
        
        for (var i = 0; i < produtos.length; i++) {
            if (produtos[i].codigo == produtoCodigo) {
                precoUnitarioInput.value = produtos[i].preco;
                estoqueSpan.innerText = produtos[i].quantidade_estoque;
                break;
            }
        }
        calcularTotal();
    }
    </script>
</head>
<body>
<div class="container mt-4">
    <h2>Inclusão de Venda</h2>
    <form method="post" action="vendaInclusao_SQL.php">
        <div class="mb-3">
            <label class="form-label">Data e Hora (*):</label>
            <input class="form-control" type="datetime-local" name="data_hora" required>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Vendedor (*):</label>
            <select class="form-select" name="vendedor_matricula" required>
                <option value="">Selecione um vendedor</option>
                <?php
                mysqli_data_seek($vendedores, 0);
                while ($vendedor = mysqli_fetch_assoc($vendedores)) {
                    echo "<option value='" . $vendedor['matricula'] . "'>" . 
                         htmlspecialchars($vendedor['nome']) . " (Matrícula: " . $vendedor['matricula'] . ")</option>";
                }
                ?>
            </select>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Cliente (*):</label>
            <select class="form-select" name="cliente_cpf" required>
                <option value="">Selecione um cliente</option>
                <?php
                mysqli_data_seek($clientes, 0);
                while ($cliente = mysqli_fetch_assoc($clientes)) {
                    echo "<option value='" . $cliente['cpf'] . "'>" . 
                         htmlspecialchars($cliente['nome']) . " (CPF: " . $cliente['cpf'] . ")</option>";
                }
                ?>
            </select>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Produto (*):</label>
            <select class="form-select" id="produto_codigo" name="produto_codigo" required onchange="atualizarPreco()">
                <option value="">Selecione um produto</option>
                <?php
                mysqli_data_seek($produtos, 0);
                while ($produto = mysqli_fetch_assoc($produtos)) {
                    echo "<option value='" . $produto['codigo'] . "' data-preco='" . $produto['preco'] . 
                         "' data-estoque='" . $produto['quantidade_estoque'] . "'>" . 
                         htmlspecialchars($produto['descricao']) . " (Código: " . $produto['codigo'] . 
                         " - R$ " . number_format($produto['preco'], 2, ',', '.') . " - Estoque: " . 
                         $produto['quantidade_estoque'] . ")</option>";
                }
                ?>
            </select>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Preço Unitário:</label>
            <input class="form-control" type="number" step="0.01" id="preco_unitario" name="preco_unitario" readonly>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Estoque Disponível: <span id="estoque_atual">0</span> unidades</label>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Quantidade (*):</label>
            <input class="form-control" type="number" id="quantidade" name="quantidade" required oninput="calcularTotal()">
        </div>
        
        <div class="mb-3">
            <label class="form-label">Valor Total:</label>
            <input class="form-control" type="hidden" id="valor_total" name="valor_total">
            <div class="alert alert-info">
                <strong>Total da Venda: <span id="valor_total_display">R$ 0,00</span></strong>
            </div>
        </div>
        
        <a href="../index.html" class="btn btn-info">Menu Principal</a>
        <input class="btn btn-success" type="submit" name="confirmar" value="Confirmar Venda">
        <input class="btn btn-danger" type="reset" name="limpar" value="Limpar">
        <br/>
        <small>(*) campo obrigatório</small>
    </form>
</div>
</body>
</html>