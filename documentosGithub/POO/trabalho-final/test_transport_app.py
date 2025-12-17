import pytest
from transport_app import *

# Testes básicos para ServicoDeTransporte (classe base)
def test_servico_transporte_base():
    servico = ServicoDeTransporte("Teste", 10.0, 2.5)
    assert servico.nome == "Teste"
    assert servico.tarifa_base == 10.0
    assert servico.preco_km == 2.5

# Testes para ModalidadePadrao
def test_modalidade_padrao():
    padrao = ModalidadePadrao(5.0, 2.0, 1.2)
    assert padrao.nome == "Padrão"
    assert padrao.tarifa_base == 5.0
    assert padrao.preco_km == 2.0
    assert padrao.taxa_bandeira == 1.2
    
    # Teste cálculo
    resultado = padrao.calcular_valor_corrida(10.0, 15.0)
    assert resultado == 36.5  # 5 + (10*2*1.2) + (15*0.5)

# Testes para ModalidadeLuxo
def test_modalidade_luxo():
    luxo = ModalidadeLuxo(5.0, 2.0, 15.0)
    assert luxo.nome == "Luxo"
    assert luxo.tarifa_base == 5.0
    assert luxo.preco_km == 2.0
    assert luxo.tarifa_cancelamento == 15.0
    
    # Teste cálculo (20% sobre base)
    resultado = luxo.calcular_valor_corrida(10.0, 15.0)
    assert resultado == 39.0  # (5 + 20 + 7.5) * 1.2

# Testes para Veiculo
def test_veiculo():
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    assert veiculo.placa == "ABC-1234"
    assert veiculo.modelo == "Fiat Uno"
    assert veiculo.servico_associado is None

def test_veiculo_associar_servico():
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    assert veiculo.servico_associado == servico

def test_veiculo_associar_servico_invalido():
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    with pytest.raises(ValueError, match="Serviço deve ser instância de ServicoDeTransporte"):
        veiculo.associar_servico("invalido")

def test_veiculo_realizar_corrida():
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    
    resultado = veiculo.realizar_corrida(10.0, 15.0)
    assert resultado == 36.5

def test_veiculo_realizar_corrida_sem_servico():
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    with pytest.raises(ValueError, match="Veículo não possui serviço associado"):
        veiculo.realizar_corrida(10.0, 15.0)

def test_veiculo_realizar_corrida_dados_invalidos():
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    
    with pytest.raises(ValueError, match="Distância deve ser maior que zero"):
        veiculo.realizar_corrida(0, 15.0)
    
    with pytest.raises(ValueError, match="Tempo deve ser maior que zero"):
        veiculo.realizar_corrida(10.0, 0)

# Testes para Corrida
def test_corrida():
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    
    corrida = Corrida(veiculo, 10.0, 15.0)
    assert corrida.veiculo_utilizado == veiculo
    assert corrida.distancia_km == 10.0
    assert corrida.tempo_minutos == 15.0
    assert corrida.valor_total_pago == 36.5
    assert corrida.data_hora is not None

# Testes para PlataformaDeTransporte
def test_plataforma():
    plataforma = PlataformaDeTransporte()
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    
    plataforma.adicionar_veiculo(veiculo)
    corrida = plataforma.registrar_corrida(veiculo, 10.0, 15.0)
    assert corrida.valor_total_pago == 36.5

def test_plataforma_adicionar_veiculo_invalido():
    plataforma = PlataformaDeTransporte()
    with pytest.raises(ValueError, match="Objeto deve ser instância de Veiculo"):
        plataforma.adicionar_veiculo("invalido")

def test_plataforma_veiculo_nao_cadastrado():
    plataforma = PlataformaDeTransporte()
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    
    with pytest.raises(ValueError, match="Veículo não cadastrado na plataforma"):
        plataforma.registrar_corrida(veiculo, 10.0, 15.0)

# Testes de herança
def test_heranca():
    padrao = ModalidadePadrao(5.0, 2.0, 1.2)
    luxo = ModalidadeLuxo(5.0, 2.0, 15.0)
    
    assert isinstance(padrao, ServicoDeTransporte)
    assert isinstance(luxo, ServicoDeTransporte)

# Testes de polimorfismo
def test_polimorfismo():
    padrao = ModalidadePadrao(5.0, 2.0, 1.2)
    luxo = ModalidadeLuxo(5.0, 2.0, 15.0)
    
    valor_padrao = padrao.calcular_valor_corrida(10.0, 15.0)
    valor_luxo = luxo.calcular_valor_corrida(10.0, 15.0)
    
    assert valor_padrao == 36.5
    assert valor_luxo == 39.0
    assert valor_padrao != valor_luxo

# Teste de associação 1:1
def test_associacao_1_1():
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico1 = ModalidadePadrao(5.0, 2.0, 1.2)
    servico2 = ModalidadeLuxo(5.0, 2.0, 15.0)
    
    veiculo.associar_servico(servico1)
    assert veiculo.servico_associado == servico1
    
    veiculo.associar_servico(servico2)
    assert veiculo.servico_associado == servico2