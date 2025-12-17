import pytest
from datetime import datetime
from transport_app import (
    ServicoDeTransporte, ModalidadePadrao, ModalidadeLuxo,
    Veiculo, Corrida, PlataformaDeTransporte
)

class TestServicoDeTransporte:
    """Testes para a classe base ServicoDeTransporte"""
    
    def test_servico_base_nao_pode_ser_instanciado(self):
        """ServicoDeTransporte é uma classe abstrata"""
        servico = ServicoDeTransporte("Teste", 1.0, 1.0)
        # Testamos que o método abstrato levanta NotImplementedError
        try:
            servico.calcular_valor_corrida(10, 15)
            assert False, "Deveria ter levantado NotImplementedError"
        except NotImplementedError:
            assert True  # Comportamento esperado
    
    def test_propriedades_herdadas(self):
        """Subclasses devem herdar propriedades da classe base"""
        padrao = ModalidadePadrao(5.0, 2.0, 1.2)
        
        assert padrao.nome == "Padrão"
        assert padrao.tarifa_base == 5.0
        assert padrao.preco_km == 2.0
        assert padrao.taxa_bandeira == 1.2

class TestModalidadePadrao:
    """Testes específicos para ModalidadePadrao"""
    
    def test_calculo_corrida_padrao(self):
        """Cálculo do valor da corrida na modalidade padrão"""
        padrao = ModalidadePadrao(5.0, 2.0, 1.2)
        # 5.0 + (10 × 2.0 × 1.2) + (15 × 0.5) = 5 + 24 + 7.5 = 36.5
        valor = padrao.calcular_valor_corrida(10.0, 15.0)
        assert valor == 36.5
    
    def test_calculo_com_taxa_diferente(self):
        """Teste com taxa bandeira diferente"""
        padrao = ModalidadePadrao(5.0, 2.0, 1.5)  # Taxa mais alta
        # 5.0 + (10 × 2.0 × 1.5) + (15 × 0.5) = 5 + 30 + 7.5 = 42.5
        valor = padrao.calcular_valor_corrida(10.0, 15.0)
        assert valor == 42.5

class TestModalidadeLuxo:
    """Testes específicos para ModalidadeLuxo"""
    
    def test_calculo_corrida_luxo(self):
        """Cálculo do valor da corrida na modalidade luxo"""
        luxo = ModalidadeLuxo(8.0, 3.0, 15.0)
        # 1. Cálculo como padrão: 8.0 + (10 × 3.0 × 1.0) + (15 × 0.5) = 8 + 30 + 7.5 = 45.5
        # 2. +20%: 45.5 × 1.2 = 54.6
        valor = luxo.calcular_valor_corrida(10.0, 15.0)
        assert valor == 54.6
    
    def test_propriedade_tarifa_cancelamento(self):
        """Modalidade luxo deve ter tarifa de cancelamento"""
        luxo = ModalidadeLuxo(8.0, 3.0, 15.0)
        assert luxo.tarifa_cancelamento == 15.0

class TestVeiculo:
    """Testes para a classe Veiculo"""
    
    @pytest.fixture
    def veiculo(self):
        """Fixture para criar um veículo padrão"""
        return Veiculo("ABC-1234", "Fiat Uno")
    
    @pytest.fixture
    def servico_padrao(self):
        """Fixture para criar serviço padrão"""
        return ModalidadePadrao(5.0, 2.0, 1.2)
    
    def test_criacao_veiculo(self, veiculo):
        """Teste de criação básica do veículo"""
        assert veiculo.placa == "ABC-1234"
        assert veiculo.modelo == "Fiat Uno"
        assert veiculo.servico_associado is None
    
    def test_associar_servico_valido(self, veiculo, servico_padrao):
        """Associação de serviço válido"""
        veiculo.associar_servico(servico_padrao)
        assert veiculo.servico_associado == servico_padrao
        assert veiculo.servico_associado.nome == "Padrão"
    
    def test_associar_servico_invalido(self, veiculo):
        """Não deve aceitar serviço inválido"""
        try:
            veiculo.associar_servico("servico_invalido")
            assert False, "Deveria ter levantado ValueError para serviço inválido"
        except ValueError:
            assert True  # Comportamento esperado
    
    def test_realizar_corrida_sem_servico(self, veiculo):
        """Não deve realizar corrida sem serviço associado"""
        try:
            veiculo.realizar_corrida(10.0, 15.0)
            assert False, "Deveria ter levantado erro sem serviço associado"
        except ValueError:
            assert True  # Comportamento esperado
    
    def test_realizar_corrida_parametros_invalidos(self, veiculo, servico_padrao):
        """Não deve aceitar parâmetros inválidos"""
        veiculo.associar_servico(servico_padrao)
        
        # Distância zero ou negativa
        try:
            veiculo.realizar_corrida(0, 15.0)
            assert False, "Deveria ter levantado erro para distância zero"
        except ValueError:
            assert True  # Comportamento esperado
        
        # Tempo zero ou negativo
        try:
            veiculo.realizar_corrida(10.0, -5.0)
            assert False, "Deveria ter levantado erro para tempo negativo"
        except ValueError:
            assert True  # Comportamento esperado
    
    def test_realizar_corrida_valida(self, veiculo, servico_padrao):
        """Corrida com parâmetros válidos deve funcionar"""
        veiculo.associar_servico(servico_padrao)
        valor = veiculo.realizar_corrida(10.0, 15.0)
        assert valor == 36.5

class TestCorrida:
    """Testes para a classe Corrida"""
    
    @pytest.fixture
    def veiculo_com_servico(self):
        """Fixture para criar veículo com serviço"""
        veiculo = Veiculo("ABC-1234", "Fiat Uno")
        servico = ModalidadePadrao(5.0, 2.0, 1.2)
        veiculo.associar_servico(servico)
        return veiculo
    
    def test_criacao_corrida(self, veiculo_com_servico):
        """Teste de criação básica da corrida"""
        corrida = Corrida(veiculo_com_servico, 10.0, 15.0)
        
        assert corrida.veiculo_utilizado == veiculo_com_servico
        assert corrida.distancia_km == 10.0
        assert corrida.tempo_minutos == 15.0
        assert corrida.valor_total_pago == 36.5
        assert isinstance(corrida.data_hora, datetime)
    
    def test_exibir_resumo(self, veiculo_com_servico, capsys):
        """Teste do método exibir_resumo"""
        corrida = Corrida(veiculo_com_servico, 10.0, 15.0)
        corrida.exibir_resumo()
        
        output = capsys.readouterr().out
        assert "Corrida registrada" in output
        assert "Fiat Uno" in output
        assert "ABC-1234" in output
        assert "36.50" in output

class TestPlataformaDeTransporte:
    """Testes para a classe PlataformaDeTransporte"""
    
    @pytest.fixture
    def plataforma(self):
        """Fixture para criar plataforma"""
        return PlataformaDeTransporte()
    
    @pytest.fixture
    def veiculo_cadastravel(self):
        """Fixture para criar veículo para cadastro"""
        veiculo = Veiculo("ABC-1234", "Fiat Uno")
        servico = ModalidadePadrao(5.0, 2.0, 1.2)
        veiculo.associar_servico(servico)
        return veiculo
    
    def test_adicionar_veiculo_valido(self, plataforma, veiculo_cadastravel):
        """Adição de veículo válido"""
        plataforma.adicionar_veiculo(veiculo_cadastravel)
        # Testamos indiretamente - se não deu erro, está ok
        assert True
    
    def test_adicionar_veiculo_invalido(self, plataforma):
        """Não deve aceitar veículo inválido"""
        objeto_invalido = "não é um veículo"
        
        try:
            plataforma.adicionar_veiculo(objeto_invalido)
            assert False, "Deveria ter levantado ValueError para objeto inválido"
        except ValueError:
            assert True  # Comportamento esperado
    
    def test_registrar_corrida_veiculo_nao_cadastrado(self, plataforma, veiculo_cadastravel):
        """Não deve registrar corrida de veículo não cadastrado"""
        try:
            plataforma.registrar_corrida(veiculo_cadastravel, 10.0, 15.0)
            assert False, "Deveria ter levantado erro para veículo não cadastrado"
        except ValueError:
            assert True  # Comportamento esperado
    
    def test_registrar_corrida_valida(self, plataforma, veiculo_cadastravel):
        """Registro de corrida válida"""
        plataforma.adicionar_veiculo(veiculo_cadastravel)
        corrida = plataforma.registrar_corrida(veiculo_cadastravel, 10.0, 15.0)
        
        assert isinstance(corrida, Corrida)
        assert corrida.valor_total_pago == 36.5
    
    def test_resumo_faturamento_diario(self, plataforma, veiculo_cadastravel):
        """Teste do resumo de faturamento diário"""
        plataforma.adicionar_veiculo(veiculo_cadastravel)
        
        # Registrar algumas corridas
        corrida1 = plataforma.registrar_corrida(veiculo_cadastravel, 10.0, 15.0)  # 36.5
        corrida2 = plataforma.registrar_corrida(veiculo_cadastravel, 5.0, 10.0)   # Cálculo: 5 + (5×2×1.2) + (10×0.5) = 5 + 12 + 5 = 22
        
        total = corrida1.valor_total_pago + corrida2.valor_total_pago  # 36.5 + 22 = 58.5
        
        # Testar o resumo
        faturamento = plataforma.resumo_faturamento_diario()
        assert faturamento == total
    
    def test_exibir_detalhes_corrida(self, plataforma, veiculo_cadastravel, capsys):
        """Teste do método polimórfico exibir_detalhes_corrida"""
        plataforma.adicionar_veiculo(veiculo_cadastravel)
        corrida = plataforma.registrar_corrida(veiculo_cadastravel, 10.0, 15.0)
        
        plataforma.exibir_detalhes_corrida(corrida)
        output = capsys.readouterr().out
        
        assert "Corrida registrada" in output
        assert "36.50" in output

class TestIntegracao:
    """Testes de integração entre todas as classes"""
    
    def test_fluxo_completo(self):
        """Teste do fluxo completo do sistema"""
        # 1. Criar serviços
        padrao = ModalidadePadrao(5.0, 2.0, 1.2)
        luxo = ModalidadeLuxo(8.0, 3.0, 15.0)
        
        # 2. Criar veículos
        carro1 = Veiculo("ABC-1234", "Fiat Uno")
        carro2 = Veiculo("XYZ-5678", "Toyota Corolla")
        
        # 3. Associar serviços
        carro1.associar_servico(padrao)
        carro2.associar_servico(luxo)
        
        # 4. Criar plataforma
        plataforma = PlataformaDeTransporte()
        
        # 5. Cadastrar veículos
        plataforma.adicionar_veiculo(carro1)
        plataforma.adicionar_veiculo(carro2)
        
        # 6. Registrar corridas
        corrida1 = plataforma.registrar_corrida(carro1, 10.0, 15.0)
        corrida2 = plataforma.registrar_corrida(carro2, 10.0, 15.0)
        
        # 7. Verificar valores (polimorfismo)
        assert corrida1.valor_total_pago == 36.5  # Padrão
        assert corrida2.valor_total_pago == 54.6  # Luxo (+20%)
        
        # 8. Verificar faturamento
        faturamento = plataforma.resumo_faturamento_diario()
        assert faturamento == 36.5 + 54.6  # 91.1
        
        print(f"✓ Fluxo completo testado com sucesso!")
        print(f"  Corrida Padrão: R$ {corrida1.valor_total_pago:.2f}")
        print(f"  Corrida Luxo: R$ {corrida2.valor_total_pago:.2f}")
        print(f"  Faturamento total: R$ {faturamento:.2f}")
    
    def test_polimorfismo_entre_modalidades(self):
        """Demonstração clara do polimorfismo"""
        padrao = ModalidadePadrao(5.0, 2.0, 1.2)
        luxo = ModalidadeLuxo(8.0, 3.0, 15.0)
        
        # Mesma chamada de método, resultados diferentes
        valor_padrao = padrao.calcular_valor_corrida(10.0, 15.0)
        valor_luxo = luxo.calcular_valor_corrida(10.0, 15.0)
        
        # Verificamos que são diferentes (polimorfismo)
        assert valor_padrao != valor_luxo
        assert valor_padrao == 36.5
        assert valor_luxo == 54.6

# Testes adicionais sem fixtures
def test_criacao_objetos_basicos():
    """Testes básicos de criação de objetos"""
    # Teste Serviço Padrão
    padrao = ModalidadePadrao(5.0, 2.0, 1.2)
    assert padrao.nome == "Padrão"
    assert padrao.tarifa_base == 5.0
    
    # Teste Serviço Luxo
    luxo = ModalidadeLuxo(8.0, 3.0, 15.0)
    assert luxo.nome == "Luxo"
    assert luxo.tarifa_base == 8.0
    
    # Teste Veículo
    veiculo = Veiculo("TEST-001", "Teste Modelo")
    assert veiculo.placa == "TEST-001"
    assert veiculo.modelo == "Teste Modelo"
    
    print("✓ Criação de objetos básicos testada com sucesso!")

def test_associacao_1_1():
    """Teste da associação 1:1 entre Veículo e Serviço"""
    veiculo = Veiculo("ASSOC-001", "Carro Teste")
    servico = ModalidadePadrao(5.0, 2.0, 1.2)
    
    # Antes da associação
    assert veiculo.servico_associado is None
    
    # Após associação
    veiculo.associar_servico(servico)
    assert veiculo.servico_associado is not None
    assert veiculo.servico_associado.nome == "Padrão"
    
    print("✓ Associação 1:1 testada com sucesso!")

def test_heranca_polimorfismo():
    """Teste explícito de herança e polimorfismo"""
    # Ambos herdam de ServicoDeTransporte
    padrao = ModalidadePadrao(5.0, 2.0, 1.2)
    luxo = ModalidadeLuxo(8.0, 3.0, 15.0)
    
    # Verificar herança
    assert isinstance(padrao, ServicoDeTransporte)
    assert isinstance(luxo, ServicoDeTransporte)
    
    # Verificar polimorfismo - mesmo método, implementações diferentes
    # Padrão: tarifa_base + (distancia_km * preco_km * taxa_bandeira) + (tempo_minutos * 0.5)
    # Luxo: [tarifa_base + (distancia_km * preco_km * 1.0) + (tempo_minutos * 0.5)] * 1.2
    
    resultado_padrao = padrao.calcular_valor_corrida(5, 10)
    resultado_luxo = luxo.calcular_valor_corrida(5, 10)
    
    assert resultado_padrao != resultado_luxo
    print("✓ Herança e polimorfismo testados com sucesso!")