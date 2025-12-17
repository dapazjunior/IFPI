class ServicoDeTransporte:
    def __init__(self, nome, tarifa_base, preco_km):
        self.nome = nome
        self.tarifa_base = tarifa_base
        self.preco_km = preco_km

    def calcular_valor_corrida(self, distancia_km, tempo_minutos):
        raise NotImplementedError("Método deve ser sobrescrito")


class ModalidadePadrao(ServicoDeTransporte):
    def __init__(self, tarifa_base, preco_km, taxa_bandeira):
        super().__init__("Padrão", tarifa_base, preco_km)
        self.taxa_bandeira = taxa_bandeira

    def calcular_valor_corrida(self, distancia_km, tempo_minutos):
        if distancia_km <= 0 or tempo_minutos <= 0:
            raise ValueError("Distância e tempo devem ser positivos")

        return (
            self.tarifa_base +
            (distancia_km * self.preco_km * self.taxa_bandeira) +
            (tempo_minutos * 0.5)
        )


class ModalidadeLuxo(ServicoDeTransporte):
    def __init__(self, tarifa_base, preco_km, taxa_bandeira, tarifa_cancelamento):
        super().__init__("Luxo", tarifa_base, preco_km)
        self.taxa_bandeira = taxa_bandeira
        self.tarifa_cancelamento = tarifa_cancelamento

    def calcular_valor_corrida(self, distancia_km, tempo_minutos):
        valor_padrao = (
            self.tarifa_base +
            (distancia_km * self.preco_km * self.taxa_bandeira) +
            (tempo_minutos * 0.5)
        )
        return valor_padrao * 1.2


class Veiculo:
    def __init__(self, placa, modelo):
        self.placa = placa
        self.modelo = modelo
        self.servico_associado = None

    def associar_servico(self, servico):
        self.servico_associado = servico

    def realizar_corrida(self, distancia_km, tempo_minutos):
        if not self.servico_associado:
            raise Exception("Veículo sem serviço associado")

        return self.servico_associado.calcular_valor_corrida(
            distancia_km, tempo_minutos
        )


class Corrida:
    def __init__(self, veiculo, distancia_km, tempo_minutos):
        self.veiculo_utilizado = veiculo
        self.distancia_km = distancia_km
        self.tempo_minutos = tempo_minutos
        self.valor_total_pago = None

    def registrar_corrida(self):
        self.valor_total_pago = self.veiculo_utilizado.realizar_corrida(
            self.distancia_km, self.tempo_minutos
        )

    def exibir_resumo(self):
        print(f"Veículo: {self.veiculo_utilizado.placa}")
        print(f"Modalidade: {self.veiculo_utilizado.servico_associado.nome}")
        print(f"Distância: {self.distancia_km} km")
        print(f"Tempo: {self.tempo_minutos} min")
        print(f"Valor pago: R$ {self.valor_total_pago:.2f}")


