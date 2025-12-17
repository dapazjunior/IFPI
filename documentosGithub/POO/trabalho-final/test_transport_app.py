import pytest
from transport_app import *

# Testes para ModalidadePadrao
def test_calculo_modalidade_padrao():
    padrao = ModalidadePadrao(5.0, 2.0, 1.2)
    assert padrao.calcular_valor_corrida(10.0, 15.0) == 36.5

def test_heranca_modalidade_padrao():
    padrao = ModalidadePadrao(5.0, 2.0, 1.2)
    assert isinstance(padrao, ServicoDeTransporte)

# Testes para ModalidadeLuxo
def test_calculo_modalidade_luxo():
    luxo = ModalidadeLuxo(5.0, 2.0, 15.0)
    # Cálculo: (5 + (10×2) + (15×0.5)) × 1.2 = (5 + 20 + 7.5) × 1.2 = 32.5 × 1.2 = 39.0
    assert luxo.calcular_valor_corrida(10.0, 15.0) == 39.0

def test_luxo_20_porcento_mais_caro_que_base():
    luxo = ModalidadeLuxo(5.0, 2.0, 15.0)
    valor_base = 5.0 + (10.0 * 2.0) + (15.0 * 0.5)  # 32.5
    valor_luxo = luxo.calcular_valor_corrida(10.0, 15.0)
    assert valor_luxo == valor_base * 1.2

# Testes para Veiculo
def test_veiculo_associar_servico():
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    assert veiculo.servico_associado == servico

def test_veiculo_realizar_corrida_sem_servico():
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    try:
        veiculo.realizar_corrida(10.0, 15.0)
        assert False
    except ValueError as e:
        assert "Veículo não possui serviço associado" in str(e)

# Testes para PlataformaDeTransporte
def test_plataforma_registrar_corrida_veiculo_nao_cadastrado():
    plataforma = PlataformaDeTransporte()
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    
    try:
        plataforma.registrar_corrida(veiculo, 10.0, 15.0)
        assert False
    except ValueError as e:
        assert "Veículo não cadastrado na plataforma" in str(e)

# Teste de polimorfismo
def test_polimorfismo_calculo_corrida():
    padrao = ModalidadePadrao(5.0, 2.0, 1.2)
    luxo = ModalidadeLuxo(5.0, 2.0, 15.0)
    
    valor_padrao = padrao.calcular_valor_corrida(10.0, 15.0)
    valor_luxo = luxo.calcular_valor_corrida(10.0, 15.0)
    
    assert valor_padrao != valor_luxo
    assert valor_luxo == 39.0

# Teste de encapsulamento
def test_encapsulamento():
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    assert servico.nome == "Padrão"
    assert servico.tarifa_base == 5.0
    assert servico.preco_km == 2.0
    assert servico.taxa_bandeira == 1.2