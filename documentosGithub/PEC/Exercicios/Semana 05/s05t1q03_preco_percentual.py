def main():
    valor = float(input())
    porcentagem = float(input())
    
    porcentagem = porcentagem_em_decimal(porcentagem)

    valor_aumentado = aumento_percentual(valor, porcentagem)
    valor_descontado = desconto_percentual(valor, porcentagem)

    print(f'{valor_aumentado:.2f}')
    print(f'{valor_descontado:.2f}')

def porcentagem_em_decimal(porcentagem):
    porcentagem = porcentagem / 100
    return porcentagem

def aumento_percentual(valor, percentual):
    valor = valor * (1 + percentual)
    return valor

def desconto_percentual(valor, percentual):
    valor = valor * (1 - percentual)
    return valor

main()