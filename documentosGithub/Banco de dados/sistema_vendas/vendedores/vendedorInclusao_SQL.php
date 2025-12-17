<?php
header('Content-Type: text/html; charset=utf-8');
require_once('../conexao.php');

echo "<div class='container mt-4'>";
echo "<h2>Inclusão de Vendedor</h2>";

// Limpar e capturar dados
$nome = limpar($_POST["nome"]);
$endereco = limpar($_POST["endereco"]);
$telefone = limpar($_POST["telefone"]);
$cpf = limpar($_POST["cpf"]);
$salario_base = limpar($_POST["salario_base"]);
$comissao = limpar($_POST["comissao"]);

// Preparar comando SQL
$comando = "INSERT INTO vendedores (nome, endereco, telefone, cpf, salario_base, comissao) 
            VALUES ('$nome', '$endereco', '$telefone', '$cpf', '$salario_base', '$comissao')";

// Executar comando
if (mysqli_query($conexao, $comando)) {
    echo "<div class='alert alert-success'>Vendedor incluído com sucesso!</div>";
} else {
    // Verificar se é erro de duplicidade de CPF
    if (mysqli_errno($conexao) == 1062) {
        echo "<div class='alert alert-warning'>O CPF <b>$cpf</b> já está cadastrado.</div>";
    } else {
        echo "<div class='alert alert-danger'>Erro ao incluir vendedor: " . mysqli_error($conexao) . "</div>";
    }
}

echo "<p><a href='javascript:history.back();' class='btn btn-secondary'>Voltar</a></p>";
echo "<p><a href='../index.html' class='btn btn-info'>Menu Principal</a></p>";
echo "</div>";

mysqli_close($conexao);
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
</body>
</html>