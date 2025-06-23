def main():
    salario = float(input())
    divida = float(input())

    meses = divida_supera_salario(divida, salario)

    mes_atual, ano_atual = atualizar_data(10, 2016, meses)

    print(f'{mes_atual}/{ano_atual}')


def divida_supera_salario(divida, salario):
    ano = 0
    meses_totais = 1
    mes_atual = 10

    divida_atualizada = divida
    salario_atualizado = salario

    while divida_atualizada < salario_atualizado:
        divida_atualizada = atualizar_valor(divida, 0.15, meses_totais)
        mes_atual += 1
        meses_totais += 1


        
        if mes_atual == 13:
            mes_atual = 1
            ano += 1
        
        if mes_atual == 3:
            salario_atualizado = atualizar_valor(salario, 0.05, ano)
    
    return meses_totais - 1
    

def atualizar_valor(valor, taxa, tempo):
    return (valor * ((1 + taxa) ** tempo))


def atualizar_data(mes_inicial, ano_inicial, meses_passados):
    anos_passados = meses_passados // 12
    meses_passados = meses_passados % 12

    mes_atual = mes_inicial + meses_passados
    ano_autal = ano_inicial + anos_passados

    if mes_atual > 12:
        ano_autal += 1
        mes_atual = mes_atual % 12

    return mes_atual, ano_autal


if __name__ == "__main__":
    main()