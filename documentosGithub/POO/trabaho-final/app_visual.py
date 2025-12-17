from modelos import ModalidadePadrao, ModalidadeLuxo, Veiculo
from plataforma import PlataformaDeTransporte

plataforma = PlataformaDeTransporte()

# Serviços
padrao = ModalidadePadrao(5, 2, 1.2)
luxo = ModalidadeLuxo(8, 3, 1.3, 15)

# Veículos
v1 = Veiculo("ABC-1234", "Onix")
v2 = Veiculo("XYZ-9999", "Corolla")

v1.associar_servico(padrao)
v2.associar_servico(luxo)

plataforma.adicionar_veiculo(v1)
plataforma.adicionar_veiculo(v2)

# Corridas válidas
corrida1 = plataforma.registrar_corrida(v1, 10, 15)
corrida1.exibir_resumo()

print("-" * 30)

corrida2 = plataforma.registrar_corrida(v2, 8, 12)
corrida2.exibir_resumo()

print("-" * 30)

# Exceção: veículo sem serviço
try:
    v3 = Veiculo("ERR-0000", "Gol")
    plataforma.registrar_corrida(v3, 5, 10)
except Exception as e:
    print("Erro:", e)

# Exceção: valores inválidos
try:
    plataforma.registrar_corrida(v1, -3, 10)
except ValueError as e:
    print("Erro:", e)

print("-" * 30)
print("Faturamento total do dia: R$",
      plataforma.resumo_faturamento_diario())
