from datetime import datetime

# 1. Classe Base: ServicoDeTransporte (Superclasse)

class ServicoDeTransporte:
    def __init__(self, nome, tarifa_base, preco_km):
        self.__nome = nome
        self.__tarifa_base = tarifa_base
        self.__preco_km = preco_km
    
    @property
    def nome(self):
        return self.__nome
    
    @property
    def tarifa_base(self):
        return self.__tarifa_base
    
    @property
    def preco_km(self):
        return self.__preco_km
    
    def calcular_valor_corrida(self, distancia_km, tempo_minutos):
        """Cálculo genérico que os filhos podem adaptar"""
        return self.__tarifa_base + (distancia_km * self.__preco_km) + (tempo_minutos * 0.5)

    """
    def calcular_valor_corrida(self, distancia_km, tempo_minutos):
        raise NotImplementedError("Método deve ser implementado nas subclasses")
    """

# 2. Subclasses (Herança e Polimorfismo)

class ModalidadePadrao(ServicoDeTransporte):
    def __init__(self, tarifa_base, preco_km, taxa_bandeira):
        super().__init__("Padrão", tarifa_base, preco_km)
        self.__taxa_bandeira = taxa_bandeira
    
    @property
    def taxa_bandeira(self):
        return self.__taxa_bandeira
    
    def calcular_valor_corrida(self, distancia_km, tempo_minutos):
        """Sobrescreve cálculo do pai aplicando taxa_bandeira"""
        # Método 1: Recalcula tudo (mais simples)
        return self.tarifa_base + (distancia_km * self.preco_km * self.taxa_bandeira) + (tempo_minutos * 0.5)
           
    """
    def calcular_valor_corrida(self, distancia_km, tempo_minutos):
        # Cálculo: tarifa_base + (distancia_km * preco_km * taxa_bandeira) + (tempo_minutos * 0.5)
        return self.tarifa_base + (distancia_km * self.preco_km * self.taxa_bandeira) + (tempo_minutos * 0.5)
    """

class ModalidadeLuxo(ServicoDeTransporte):
    def __init__(self, tarifa_base, preco_km, tarifa_cancelamento):
        super().__init__("Luxo", tarifa_base, preco_km)
        self.__tarifa_cancelamento = tarifa_cancelamento
    
    @property
    def tarifa_cancelamento(self):
        return self.__tarifa_cancelamento
    
    def calcular_valor_corrida(self, distancia_km, tempo_minutos):
        """20% sobre cálculo genérico do pai (ServicoDeTransporte)"""
        # Método ATUAL: usa cálculo do pai diretamente
        valor_base = super().calcular_valor_corrida(distancia_km, tempo_minutos)
        
        # Aplica 20% sobre o valor base
        return valor_base * 1.2
        
    """
    def calcular_valor_corrida(self, distancia_km, tempo_minutos):
        # Primeiro calcula como se fosse Padrão com taxa_bandeira = 1.0
        valor_como_padrao = self.tarifa_base + (distancia_km * self.preco_km * 1.0) + (tempo_minutos * 0.5)
        
        # Aplica acréscimo de 20% sobre o valor da Modalidade Padrão
        return valor_como_padrao * 1.2
    """

# 3. Classe Associação 1:1: Veículo

class Veiculo:
    def __init__(self, placa, modelo):
        self.__placa = placa
        self.__modelo = modelo
        self.__servico_associado = None
    
    @property
    def placa(self):
        return self.__placa
    
    @property
    def modelo(self):
        return self.__modelo
    
    @property
    def servico_associado(self):
        return self.__servico_associado
    
    def associar_servico(self, servico):
        if not isinstance(servico, ServicoDeTransporte):
            raise ValueError("Serviço deve ser instância de ServicoDeTransporte")
        self.__servico_associado = servico
    
    def realizar_corrida(self, distancia_km, tempo_minutos):
        if self.__servico_associado is None:
            raise ValueError("Veículo não possui serviço associado")
        if distancia_km <= 0:
            raise ValueError("Distância deve ser maior que zero")
        if tempo_minutos <= 0:
            raise ValueError("Tempo deve ser maior que zero")
        
        return self.__servico_associado.calcular_valor_corrida(distancia_km, tempo_minutos)

# 4. Classe Transação: Corrida

class Corrida:
    def __init__(self, veiculo_utilizado, distancia_km, tempo_minutos):
        self.__veiculo_utilizado = veiculo_utilizado
        self.__distancia_km = distancia_km
        self.__tempo_minutos = tempo_minutos
        self.__data_hora = datetime.now()
        self.__valor_total_pago = veiculo_utilizado.realizar_corrida(distancia_km, tempo_minutos)
    
    @property
    def veiculo_utilizado(self):
        return self.__veiculo_utilizado
    
    @property
    def distancia_km(self):
        return self.__distancia_km
    
    @property
    def tempo_minutos(self):
        return self.__tempo_minutos
    
    @property
    def valor_total_pago(self):
        return self.__valor_total_pago
    
    @property
    def data_hora(self):
        return self.__data_hora
    
    def exibir_resumo(self):
        print(f"Corrida registrada em {self.data_hora.strftime('%d/%m/%Y %H:%M')}")
        print(f"Veículo: {self.veiculo_utilizado.modelo} - Placa: {self.veiculo_utilizado.placa}")
        print(f"Modalidade: {self.veiculo_utilizado.servico_associado.nome}")
        print(f"Distância: {self.distancia_km} km | Tempo: {self.tempo_minutos} min")
        print(f"Valor total: R$ {self.valor_total_pago:.2f}")

# 5. Classe Associação 1:N: PlataformaDeTransporte

class PlataformaDeTransporte:
    def __init__(self):
        self.__veiculos = []
        self.__historico_corridas = []
    
    def adicionar_veiculo(self, veiculo):
        if not isinstance(veiculo, Veiculo):
            raise ValueError("Objeto deve ser instância de Veiculo")
        self.__veiculos.append(veiculo)
    
    def listar_veiculos(self):
        for veiculo in self.__veiculos:
            servico = "Nenhum" if veiculo.servico_associado is None else veiculo.servico_associado.nome
            print(f"Placa: {veiculo.placa} | Modelo: {veiculo.modelo} | Serviço: {servico}")
    
    def registrar_corrida(self, veiculo, distancia_km, tempo_minutos):
        if veiculo not in self.__veiculos:
            raise ValueError("Veículo não cadastrado na plataforma")
        
        corrida = Corrida(veiculo, distancia_km, tempo_minutos)
        self.__historico_corridas.append(corrida)
        return corrida
    
    def resumo_faturamento_diario(self):
        hoje = datetime.now().date()
        total = 0
        
        for corrida in self.__historico_corridas:
            if corrida.data_hora.date() == hoje:
                total += corrida.valor_total_pago
        
        print(f"Faturamento do dia {hoje.strftime('%d/%m/%Y')}: R$ {total:.2f}")
        return total
    
    def exibir_detalhes_corrida(self, corrida):
        if isinstance(corrida, Corrida):
            corrida.exibir_resumo()
        else:
            print("Objeto não é uma corrida válida")

# EXEMPLO DE USO

if __name__ == "__main__":
    print("=" * 50)
    print("SISTEMA DE TRANSPORTE POR APLICATIVO - VERSÃO FINAL")
    print("=" * 50)
    
    # 1. Criar serviços
    padrao = ModalidadePadrao(tarifa_base=5.0, preco_km=2.0, taxa_bandeira=1.2)
    luxo = ModalidadeLuxo(tarifa_base=8.0, preco_km=3.0, tarifa_cancelamento=15.0)
    
    print("\n1. SERVIÇOS CRIADOS:")
    print(f"   Padrão: R${padrao.tarifa_base} + R${padrao.preco_km}/km × taxa {padrao.taxa_bandeira}")
    print(f"   Luxo: 20% sobre cálculo base (R${luxo.tarifa_base} + R${luxo.preco_km}/km)")
    print(f"   Cancelamento Luxo: R${luxo.tarifa_cancelamento}")
    
    # 2. Demonstrar polimorfismo
    print("\n2. DEMONSTRAÇÃO DE POLIMORFISMO (10km, 15min):")
    
    # Cálculo detalhado do Padrão
    valor_padrao = padrao.calcular_valor_corrida(10.0, 15.0)
    print(f"   Padrão: R${padrao.tarifa_base} + (10×{padrao.preco_km}×{padrao.taxa_bandeira}) + (15×0.5)")
    print(f"          = 5.0 + (10×2.0×1.2) + 7.5")
    print(f"          = 5.0 + 24.0 + 7.5 = R$ {valor_padrao:.2f}")
    
    # Cálculo detalhado do Luxo
    valor_luxo = luxo.calcular_valor_corrida(10.0, 15.0)
    print(f"\n   Luxo: [R${luxo.tarifa_base} + (10×{luxo.preco_km}) + (15×0.5)] × 1.2")
    print(f"        = [8.0 + (10×3.0) + 7.5] × 1.2")
    print(f"        = [8.0 + 30.0 + 7.5] × 1.2")
    print(f"        = 45.5 × 1.2 = R$ {valor_luxo:.2f}")
    
    print(f"\n   Polimorfismo: mesma chamada 'calcular_valor_corrida(10, 15)'")
    print(f"                resultados diferentes: R${valor_padrao:.2f} vs R${valor_luxo:.2f}")
    
    # 3. Criar veículos
    carro1 = Veiculo(placa="ABC-1234", modelo="Fiat Uno")
    carro2 = Veiculo(placa="XYZ-5678", modelo="Toyota Corolla")
    
    # 4. Associar serviços (1:1)
    carro1.associar_servico(padrao)
    carro2.associar_servico(luxo)
    
    print("\n3. VEÍCULOS E SERVIÇOS (Associação 1:1):")
    print(f"   {carro1.placa} ({carro1.modelo}) → {carro1.servico_associado.nome}")
    print(f"   {carro2.placa} ({carro2.modelo}) → {carro2.servico_associado.nome}")
    
    # 5. Criar plataforma e adicionar veículos (1:N)
    plataforma = PlataformaDeTransporte()
    plataforma.adicionar_veiculo(carro1)
    plataforma.adicionar_veiculo(carro2)
    
    print("\n4. VEÍCULOS NA PLATAFORMA (Associação 1:N):")
    plataforma.listar_veiculos()
    
    # 6. Registrar corridas
    print("\n5. REGISTRANDO CORRIDAS:")
    
    try:
        corrida1 = plataforma.registrar_corrida(carro1, distancia_km=10.0, tempo_minutos=15.0)
        print(f"   ✓ Corrida Padrão registrada")
        print(f"     Valor: R$ {corrida1.valor_total_pago:.2f}")
    except ValueError as e:
        print(f"   ✗ Erro: {e}")
    
    try:
        corrida2 = plataforma.registrar_corrida(carro2, distancia_km=10.0, tempo_minutos=15.0)
        print(f"   ✓ Corrida Luxo registrada")
        print(f"     Valor: R$ {corrida2.valor_total_pago:.2f}")
    except ValueError as e:
        print(f"   ✗ Erro: {e}")
    
    # 7. Testar tratamento de exceções
    print("\n6. TESTE DE TRATAMENTO DE ERROS:")
    
    carro3 = Veiculo(placa="DEF-9012", modelo="Ford Ka")
    
    # Teste 1: Veículo sem serviço
    try:
        carro3.realizar_corrida(5.0, 10.0)
        print("   ✗ DEVERIA ter dado erro (sem serviço)!")
    except ValueError as e:
        print(f"   ✓ Erro correto: {e}")
    
    # Teste 2: Distância inválida
    try:
        carro1.realizar_corrida(0, 15.0)
        print("   ✗ DEVERIA ter dado erro (distância zero)!")
    except ValueError as e:
        print(f"   ✓ Erro correto: {e}")
    
    # Teste 3: Veículo não cadastrado
    try:
        plataforma.registrar_corrida(carro3, 5.0, 10.0)
        print("   ✗ DEVERIA ter dado erro (veículo não cadastrado)!")
    except ValueError as e:
        print(f"   ✓ Erro correto: {e}")
    
    # 8. Faturamento
    print("\n7. RESUMO FINANCEIRO:")
    plataforma.resumo_faturamento_diario()
    
    print("\n" + "=" * 50)
    print("FIM DO SISTEMA")
    print("=" * 50)