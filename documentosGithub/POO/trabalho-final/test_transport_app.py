import pytest
from transport_app import *


# Testes para ModalidadePadrao

def test_calculo_modalidade_padrao():
    """Teste do cálculo da Modalidade Padrão com taxa_bandeira"""
    padrao = ModalidadePadrao(5.0, 2.0, 1.2)
    # 5 + (10 * 2 * 1.2) + (15 * 0.5) = 5 + 24 + 7.5 = 36.5
    resultado = padrao.calcular_valor_corrida(10.0, 15.0)
    assert resultado == 36.5

def test_calculo_modalidade_padrao_sem_taxa():
    """Teste do cálculo da Modalidade Padrão com taxa_bandeira = 1.0"""
    padrao = ModalidadePadrao(5.0, 2.0, 1.0)
    # Com taxa_bandeira = 1.0, igual ao cálculo do pai
    resultado = padrao.calcular_valor_corrida(10.0, 15.0)
    esperado = 5.0 + (10.0 * 2.0) + (15.0 * 0.5)
    assert resultado == esperado


# Testes para ModalidadeLuxo

def test_calculo_modalidade_luxo():
    """Teste do cálculo da Modalidade Luxo com 20% sobre o pai"""
    luxo = ModalidadeLuxo(5.0, 2.0, 15.0)  # CORRIGIDO: tarifa_base=5.0 (igual sua versão)
    # Cálculo: (5 + (10×2) + (15×0.5)) × 1.2 = (5 + 20 + 7.5) × 1.2 = 32.5 × 1.2 = 39.0
    resultado = luxo.calcular_valor_corrida(10.0, 15.0)
    assert resultado == 39.0

def test_luxo_usa_calculo_do_pai():
    """Teste que verifica se Luxo realmente usa cálculo do pai + 20%"""
    luxo = ModalidadeLuxo(5.0, 2.0, 15.0)
    # Verifica se realmente usa super() (cálculo do pai)
    valor_base = 5.0 + (10.0 * 2.0) + (15.0 * 0.5)  # 32.5
    valor_luxo = luxo.calcular_valor_corrida(10.0, 15.0)
    assert valor_luxo == valor_base * 1.2  # 39.0


# Testes para Veiculo

def test_veiculo_associar_servico():
    """Teste de associação válida de serviço ao veículo"""
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    assert veiculo.servico_associado == servico

def test_veiculo_associar_servico_invalido():
    """Teste de tentativa de associação inválida"""
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    
    erro_encontrado = False
    try:
        veiculo.associar_servico("não é um serviço")
    except ValueError as e:
        erro_encontrado = True
        assert "Serviço deve ser instância de ServicoDeTransporte" in str(e)
    
    assert erro_encontrado, "Deveria ter lançado ValueError"

def test_veiculo_realizar_corrida_sem_servico():
    """Teste de tentativa de corrida sem serviço associado"""
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    
    erro_encontrado = False
    try:
        veiculo.realizar_corrida(10.0, 15.0)
    except ValueError as e:
        erro_encontrado = True
        assert "Veículo não possui serviço associado" in str(e)
    
    assert erro_encontrado, "Deveria ter lançado ValueError"

def test_veiculo_realizar_corrida_distancia_invalida():
    """Teste de tentativa de corrida com distância inválida"""
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    
    erro_encontrado = False
    try:
        veiculo.realizar_corrida(0, 15.0)
    except ValueError as e:
        erro_encontrado = True
        assert "Distância deve ser maior que zero" in str(e)
    
    assert erro_encontrado, "Deveria ter lançado ValueError"

def test_veiculo_realizar_corrida_tempo_invalido():
    """Teste de tentativa de corrida com tempo inválido"""
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    
    erro_encontrado = False
    try:
        veiculo.realizar_corrida(10.0, 0)
    except ValueError as e:
        erro_encontrado = True
        assert "Tempo deve ser maior que zero" in str(e)
    
    assert erro_encontrado, "Deveria ter lançado ValueError"

def test_veiculo_realizar_corrida_valida():
    """Teste de corrida válida com serviço associado"""
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    
    resultado = veiculo.realizar_corrida(10.0, 15.0)
    assert resultado == 36.5


# Testes para PlataformaDeTransporte

def test_plataforma_adicionar_veiculo():
    """Teste de adição válida de veículo à plataforma"""
    plataforma = PlataformaDeTransporte()
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    plataforma.adicionar_veiculo(veiculo)

def test_plataforma_adicionar_veiculo_invalido():
    """Teste de tentativa de adição inválida à plataforma"""
    plataforma = PlataformaDeTransporte()
    
    erro_encontrado = False
    try:
        plataforma.adicionar_veiculo("não é um veículo")
    except ValueError as e:
        erro_encontrado = True
        assert "Objeto deve ser instância de Veiculo" in str(e)
    
    assert erro_encontrado, "Deveria ter lançado ValueError"

def test_plataforma_registrar_corrida_veiculo_nao_cadastrado():
    """Teste de tentativa de registrar corrida com veículo não cadastrado"""
    plataforma = PlataformaDeTransporte()
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    
    erro_encontrado = False
    try:
        plataforma.registrar_corrida(veiculo, 10.0, 15.0)
    except ValueError as e:
        erro_encontrado = True
        assert "Veículo não cadastrado na plataforma" in str(e)
    
    assert erro_encontrado, "Deveria ter lançado ValueError"

def test_plataforma_registrar_corrida_valida():
    """Teste de registro válido de corrida na plataforma"""
    plataforma = PlataformaDeTransporte()
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    plataforma.adicionar_veiculo(veiculo)
    
    corrida = plataforma.registrar_corrida(veiculo, 10.0, 15.0)
    assert corrida is not None
    assert corrida.valor_total_pago == 36.5


# Teste de herança

def test_heranca():
    """Teste que verifica a herança entre as classes"""
    padrao = ModalidadePadrao(5.0, 2.0, 1.2)
    luxo = ModalidadeLuxo(5.0, 2.0, 15.0)  # CORRIGIDO: tarifa_base=5.0
    
    assert isinstance(padrao, ServicoDeTransporte)
    assert isinstance(luxo, ServicoDeTransporte)
    assert isinstance(padrao, ModalidadePadrao)
    assert isinstance(luxo, ModalidadeLuxo)


# Teste de polimorfismo

def test_polimorfismo():
    """Teste de polimorfismo: mesma chamada, resultados diferentes"""
    padrao = ModalidadePadrao(5.0, 2.0, 1.2)
    luxo = ModalidadeLuxo(5.0, 2.0, 15.0)  # CORRIGIDO: mesmos valores base
    
    valor_padrao = padrao.calcular_valor_corrida(10.0, 15.0)
    valor_luxo = luxo.calcular_valor_corrida(10.0, 15.0)
    
    assert valor_padrao != valor_luxo
    assert valor_luxo == 39.0  # (5 + 20 + 7.5) × 1.2 = 32.5 × 1.2 = 39.0


# Teste de encapsulamento

def test_encapsulamento():
    """Teste do encapsulamento via properties"""
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    
    # Testa properties (getters)
    assert servico.nome == "Padrão"
    assert servico.tarifa_base == 5.0
    assert servico.preco_km == 2.0
    assert servico.taxa_bandeira == 1.2


# Teste de Corrida

def test_corrida_calcula_valor_automaticamente():
    """Teste que Corrida calcula valor automaticamente na criação"""
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    veiculo.associar_servico(servico)
    
    corrida = Corrida(veiculo, 10.0, 15.0)
    assert corrida.valor_total_pago == 36.5
    assert corrida.distancia_km == 10.0
    assert corrida.tempo_minutos == 15.0
    assert corrida.veiculo_utilizado == veiculo


# Teste de Associação 1:1

def test_associacao_1_1():
    """Teste da associação 1:1 entre Veiculo e Servico"""
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    servico1 = ModalidadePadrao(5.0, 2.0, 1.2)
    servico2 = ModalidadeLuxo(5.0, 2.0, 15.0)
    
    # Associa primeiro serviço
    veiculo.associar_servico(servico1)
    assert veiculo.servico_associado == servico1
    
    # Troca para segundo serviço (1:1 - substitui)
    veiculo.associar_servico(servico2)
    assert veiculo.servico_associado == servico2
    assert veiculo.servico_associado != servico1


# Teste de Exceções na Corrida

def test_corrida_veiculo_sem_servico():
    """Teste de criação de corrida com veículo sem serviço"""
    veiculo = Veiculo("ABC-1234", "Fiat Uno")
    # Veículo SEM serviço associado
    
    erro_encontrado = False
    try:
        corrida = Corrida(veiculo, 10.0, 15.0)
    except ValueError as e:
        erro_encontrado = True
        assert "Veículo não possui serviço associado" in str(e)
    
    assert erro_encontrado, "Deveria ter lançado ValueError"


# Teste de Múltiplos Veículos na Plataforma

def test_plataforma_multiplos_veiculos():
    """Teste que plataforma pode gerenciar múltiplos veículos"""
    plataforma = PlataformaDeTransporte()
    
    carro1 = Veiculo("ABC-1234", "Fiat Uno")
    carro2 = Veiculo("XYZ-5678", "Toyota Corolla")
    carro3 = Veiculo("DEF-9012", "Ford Ka")
    
    plataforma.adicionar_veiculo(carro1)
    plataforma.adicionar_veiculo(carro2)
    plataforma.adicionar_veiculo(carro3)
    
    # Se não deu erro, adicionou todos


# Teste de ServicoDeTransporte (classe base)

def test_servico_transporte_base():
    """Teste da classe base ServicoDeTransporte"""
    servico = ServicoDeTransporte("Teste", 10.0, 2.5)
    assert servico.nome == "Teste"
    assert servico.tarifa_base == 10.0
    assert servico.preco_km == 2.5
    
    # Testa cálculo genérico
    resultado = servico.calcular_valor_corrida(5.0, 10.0)
    assert resultado == 10.0 + (5.0 * 2.5) + (10.0 * 0.5)