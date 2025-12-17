<?php
$host = "sql308.infinityfree.com";
$usuario = "if0_39202430";
$senha = "1302Lolek";
$bd = "if0_39202430_geral";

$conexao = new mysqli($host, $usuario, $senha, $bd);

if ($conexao->connect_error) {
    echo "Erro: " . $conexao->connect_error;
} else {
    echo "Conexão bem sucedida!";
    $conexao->close();
}

// Criar conexão com UTF-8
$conexao = new mysqli($host, $usuario, $senha, $bd);

// Verificar conexão
if ($conexao->connect_error) {
    die("Não foi possível conectar ao banco de dados: " . $conexao->connect_error);
}
\
// Definir charset para UTF-8
if (!$conexao->set_charset("utf8mb4")) {
    die("Erro ao definir charset UTF-8: " . $conexao->error);
}

// Função para limpar dados
function limpar($dados) {
    global $conexao;
    return mysqli_real_escape_string($conexao, trim($dados));
}
?>