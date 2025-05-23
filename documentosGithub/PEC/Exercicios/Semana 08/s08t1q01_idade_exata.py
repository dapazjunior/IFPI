def main():
    """Lê a data atual e a data de nascimento, calcula e exibe a idade."""

    #Entrada de dados
    dia_hoje = int(input())
    mes_hoje = int(input())
    ano_hoje = int(input())

    dia = int(input())
    mes = int(input())
    ano = int(input())
    
    #Processamento
    idade = calcular_idade(dia, mes, ano, dia_hoje, mes_hoje, ano_hoje)
    
    #Saída de dados
    print(f'{idade}')


def calcular_idade(dia, mes, ano, dia_hoje, mes_hoje, ano_hoje):
    """Recebe dia, mês e ano de nascimento e a data atual.
    Retorna a idade calculada."""
    
    idade = ano_hoje - ano
    
    if mes_hoje < mes:
        idade = idade - 1
        return idade
    
    elif mes_hoje == mes:
        if dia_hoje < dia:
            idade = idade - 1
            return idade

    return idade


if __name__=="__main__":
    main()