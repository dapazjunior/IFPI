<?php
header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Alteração de Vendedor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <h2>Alteração de Vendedor</h2>
    <form method="post" action="vendedorAlteracao_SQL.php">
        <div class="mb-3">
            <label class="form-label">Matrícula do Vendedor (*):</label>
            <input class="form-control" type="number" name="matricula" required>
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