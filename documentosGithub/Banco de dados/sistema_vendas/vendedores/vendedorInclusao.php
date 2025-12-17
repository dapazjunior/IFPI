<?php
header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Inclusão de Vendedor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <h2>Inclusão de Vendedor</h2>
    <form method="post" action="vendedorInclusao_SQL.php">
        <div class="mb-3">
            <label class="form-label">Nome (*):</label>
            <input class="form-control" type="text" name="nome" size="100" maxlength="100" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Endereço:</label>
            <input class="form-control" type="text" name="endereco" size="200" maxlength="200">
        </div>
        <div class="mb-3">
            <label class="form-label">Telefone:</label>
            <input class="form-control" type="text" name="telefone" size="20" maxlength="20">
        </div>
        <div class="mb-3">
            <label class="form-label">CPF (*):</label>
            <input class="form-control" type="text" name="cpf" size="14" maxlength="14" required placeholder="000.000.000-00">
        </div>
        <div class="mb-3">
            <label class="form-label">Salário Base (*):</label>
            <input class="form-control" type="number" step="0.01" name="salario_base" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Comissão (%):</label>
            <input class="form-control" type="number" step="0.01" name="comissao" value="10.00">
        </div>
        
        <a href="../index.html" class="btn btn-info">Menu Principal</a>
        <input class="btn btn-success" type="submit" name="confirmar" value="Confirmar">
        <input class="btn btn-danger" type="reset" name="limpar" value="Limpar">
        <br/>
        <small>(*) campo obrigatório</small>
    </form>
</div>
</body>
</html>