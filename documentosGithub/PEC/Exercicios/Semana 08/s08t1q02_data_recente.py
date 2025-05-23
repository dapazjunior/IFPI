def main():
    """Lê duas datas e exibe qual delas é a mais recente."""

    #Entrada de dados
    dia1 = int(input())
    mes1 = int(input())
    ano1 = int(input())

    dia2 = int(input())
    mes2 = int(input())
    ano2 = int(input())
    
    #Processamento
    dia_recente, mes_recente, ano_recente = verifcar_data_recente(dia1, mes1, ano1, dia2, mes2, ano2)

    #Saída de dados
    print(f'{dia_recente}/{mes_recente}/{ano_recente}')


def verifcar_data_recente(d1, m1, a1, d2, m2, a2):
    """Recebe duas datas (dia, mês, ano). Retorna a data mais recente."""
    d, m, a = d1, m1, a1

    if a2 > a:
        a, m, d = a2, m2, d2
    
    elif a2 == a and m2 > m1:
        a, m, d = a2, m2, d2

    elif a2 == a and m2 == m1 and d2 > d1:
        a, m, d = a2, m2, d2
    
    return d, m, a


if __name__=="__main__":
    main()