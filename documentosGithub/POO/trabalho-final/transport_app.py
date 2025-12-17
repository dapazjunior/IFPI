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
        raise NotImplementedError("Método deve ser implementado nas subclasses")

# 2. Subclasses (Herança e Polimorfismo)
class ModalidadePadrao(ServicoDeTransporte):
    def __init__(self, tarifa_base, preco_km, taxa_bandeira):
        super().__init__("Padrão", tarifa_base, preco_km)
        self.__taxa_bandeira = taxa_bandeira
    
    @property
    def taxa_bandeira(self):
        return self.__taxa_bandeira
    
    def calcular_valor_corrida(self, distancia_km, tempo_minutos):
        # Cálculo: tarifa_base + (distancia_km * preco_km * taxa_bandeira) + (tempo_minutos * 0.5)
        return self.tarifa_base + (distancia_km * self.preco_km * self.taxa_bandeira) + (tempo_minutos * 0.5)

class ModalidadeLuxo(ServicoDeTransporte):
    def __init__(self, tarifa_base, preco_km, tarifa_cancelamento):
        super().__init__("Luxo", tarifa_base, preco_km)
        self.__tarifa_cancelamento = tarifa_cancelamento
    
    @property
    def tarifa_cancelamento(self):
        return self.__tarifa_cancelamento
    
    def calcular_valor_corrida(self, distancia_km, tempo_minutos):
        # Primeiro calcula como se fosse Padrão com taxa_bandeira = 1.0
        valor_como_padrao = self.tarifa_base + (distancia_km * self.preco_km * 1.0) + (tempo_minutos * 0.5)
        
        # Aplica acréscimo de 20% sobre o valor da Modalidade Padrão
        return valor_como_padrao * 1.2

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

# 5. Classe Transação: Corrida
class Corrida:
    def __init__(self, veiculo_utilizado, distancia_km, tempo_minutos):
        self.__veiculo_utilizado = veiculo_utilizado
        self.__distancia_km = distancia_km
        self.__tempo_minutos = tempo_minutos
        self.__data_hora = datetime.now()
        
        # Calcula valor usando o método do veículo (que usa método polimórfico)
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

# 4. Classe Associação 1:N: PlataformaDeTransporte
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
    
    # Método polimórfico para exibir detalhes (requisito adicional 1)
    def exibir_detalhes_corrida(self, corrida):
        if isinstance(corrida, Corrida):
            corrida.exibir_resumo()
        else:
            print("Objeto não é uma corrida válida")

# Exemplo de uso
if __name__ == "__main__":
    print("=== SISTEMA DE TRANSPORTE POR APLICATIVO ===\n")
    
    # Criando serviços com valores DIFERENTES (luxo é mais caro)
    padrao = ModalidadePadrao(5.0, 2.0, 1.2)  # Padrão: tarifa=5, km=2, taxa_bandeira=1.2
    luxo = ModalidadeLuxo(8.0, 3.0, 15.0)     # Luxo: tarifa=8, km=3 (mais caro), cancelamento=15
    
    print("1. Criando serviços:")
    print(f"   - Modalidade Padrão: tarifa_base=R${padrao.tarifa_base}, preco_km=R${padrao.preco_km}/km")
    print(f"   - Modalidade Luxo: tarifa_base=R${luxo.tarifa_base}, preco_km=R${luxo.preco_km}/km")
    print(f"     (Luxo tem tarifas mais altas e ainda + 20% sobre cálculo padrão)\n")
    
    # Criando veículos
    carro1 = Veiculo("ABC-1234", "Fiat Uno")
    carro2 = Veiculo("XYZ-5678", "Toyota Corolla")
    
    # Associando serviços (1:1)
    carro1.associar_servico(padrao)
    carro2.associar_servico(luxo)
    
    print("2. Associando serviços aos veículos:")
    print(f"   - {carro1.modelo} ({carro1.placa}) → Serviço {carro1.servico_associado.nome}")
    print(f"   - {carro2.modelo} ({carro2.placa}) → Serviço {carro2.servico_associado.nome}\n")
    
    # Criando plataforma
    plataforma = PlataformaDeTransporte()
    
    # Adicionando veículos (1:N)
    plataforma.adicionar_veiculo(carro1)
    plataforma.adicionar_veiculo(carro2)
    
    print("3. Veículos cadastrados na plataforma:")
    plataforma.listar_veiculos()
    print()
    
    # Registrando corridas
    print("4. Realizando corridas:")
    
    # Corrida 1: Padrão
    try:
        corrida1 = plataforma.registrar_corrida(carro1, 10.0, 15.0)  # 10km, 15min
        print("   Corrida 1 (Padrão):")
        print(f"   - Distância: 10km, Tempo: 15min")
        print(f"   - Cálculo: {padrao.tarifa_base} + (10 × {padrao.preco_km} × {padrao.taxa_bandeira}) + (15 × 0.5)")
        print(f"   - Valor: R$ {corrida1.valor_total_pago:.2f}\n")
    except ValueError as e:
        print(f"   Erro na corrida 1: {e}\n")
    
    # Corrida 2: Luxo
    try:
        corrida2 = plataforma.registrar_corrida(carro2, 10.0, 15.0)  # Mesma distância e tempo
        print("   Corrida 2 (Luxo):")
        print(f"   - Distância: 10km, Tempo: 15min")
        print(f"   - Cálculo como Padrão: {luxo.tarifa_base} + (10 × {luxo.preco_km} × 1.0) + (15 × 0.5)")
        print(f"   - Cálculo Padrão: R$ {luxo.tarifa_base + (10.0 * luxo.preco_km * 1.0) + (15.0 * 0.5):.2f}")
        print(f"   - Valor final (+20%): R$ {corrida2.valor_total_pago:.2f}\n")
    except ValueError as e:
        print(f"   Erro na corrida 2: {e}\n")
    
    # Demonstração do polimorfismo
    print("5. Demonstração do polimorfismo:")
    print("   Mesma chamada 'calcular_valor_corrida(10, 15)' resulta em:")
    print(f"   - Padrão: R$ {padrao.calcular_valor_corrida(10.0, 15.0):.2f}")
    print(f"   - Luxo: R$ {luxo.calcular_valor_corrida(10.0, 15.0):.2f}")
    print("   (Cada modalidade calcula do seu jeito!)\n")
    
    # Testando tratamento de exceções
    print("6. Testando tratamento de erros:")
    carro3 = Veiculo("DEF-9012", "Ford Ka")
    
    # Tentativa de corrida sem serviço
    try:
        print("   a) Tentando corrida sem serviço associado:")
        carro3.realizar_corrida(5.0, 10.0)
    except ValueError as e:
        print(f"      ✓ Erro capturado: {e}")
    
    # Tentativa de corrida com distância inválida
    try:
        print("   b) Tentando corrida com distância zero:")
        carro1.realizar_corrida(0, 15.0)
    except ValueError as e:
        print(f"      ✓ Erro capturado: {e}")
    
    # Tentativa de registrar corrida com veículo não cadastrado
    try:
        print("   c) Tentando registrar corrida com veículo não cadastrado:")
        plataforma.registrar_corrida(carro3, 5.0, 10.0)
    except ValueError as e:
        print(f"      ✓ Erro capturado: {e}")
    
    print()
    
    # Resumo de faturamento
    print("7. Resumo financeiro:")
    plataforma.resumo_faturamento_diario()
    
    print("\n=== FIM DA DEMONSTRAÇÃO ===")