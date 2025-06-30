def main():
    salario = float(input())  # salário inicial
    divida = float(input())   # dívida inicial

    meses = divida_supera_salario(divida, salario)  # calcula depois de quantos meses a dívida passa o salário

    mes_atual, ano_atual = atualizar_data(10, 2016, meses)  # calcula mês e ano baseado em outubro de 2016

    print(f'{mes_atual}/{ano_atual}')  # mostra a data final


def divida_supera_salario(divida, salario):
    ano = 0
    meses_totais = 1
    mes_atual = 10

    divida_atualizada = divida
    salario_atualizado = salario

    # enquanto a dívida for menor que o salário
    while divida_atualizada < salario_atualizado:
        divida_atualizada = atualizar_valor(divida, 0.15, meses_totais)  # aumenta a dívida
        mes_atual += 1
        meses_totais += 1

        if mes_atual == 13:  # chegou em dezembro, volta pra janeiro
            mes_atual = 1
            ano += 1
        
        if mes_atual == 3:  # salário só aumenta em março
            salario_atualizado = atualizar_valor(salario, 0.05, ano)

    return meses_totais - 1  # retorna quantos meses se passaram (tirando o último que passou)


def atualizar_valor(valor, taxa, tempo):
    # usa a fórmula de juros compostos
    return valor * ((1 + taxa) ** tempo)


def atualizar_data(mes_inicial, ano_inicial, meses_passados):
    anos_passados = meses_passados // 12
    meses_passados = meses_passados % 12

    mes_atual = mes_inicial + meses_passados
    ano_autal = ano_inicial + anos_passados

    if mes_atual > 12:  # se passou de dezembro, soma um ano e ajusta o mês
        ano_autal += 1
        mes_atual = mes_atual % 12

    return mes_atual, ano_autal


if __name__ == "__main__":
    main()
