from modelos import Corrida

class PlataformaDeTransporte:
    def __init__(self):
        self.__veiculos = []
        self.__historico_corridas = []

    def adicionar_veiculo(self, veiculo):
        self.__veiculos.append(veiculo)

    def listar_veiculos(self):
        return self.__veiculos

    def registrar_corrida(self, veiculo, distancia_km, tempo_minutos):
        corrida = Corrida(veiculo, distancia_km, tempo_minutos)
        corrida.registrar_corrida()
        self.__historico_corridas.append(corrida)
        return corrida

    def resumo_faturamento_diario(self):
        return sum(c.valor_total_pago for c in self.__historico_corridas)
