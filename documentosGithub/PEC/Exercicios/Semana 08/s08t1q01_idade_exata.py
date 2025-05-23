def main():
    dia_hoje = int(input())
    mes_hoje = int(input())
    ano_hoje = int(input())

    dia = int(input())
    mes = int(input())
    ano = int(input())
    
    idade = calcular_idade(dia, mes, ano, dia_hoje, mes_hoje, ano_hoje)
    
    print(f'{idade}')


def calcular_idade(dia, mes, ano, dia_hoje, mes_hoje, ano_hoje):
    idade = ano_hoje - ano
    
    if mes_hoje < mes:
        idade = idade - 1
        return idade
    
    elif mes_hoje == mes:
        if dia_hoje < dia:
            idade = idade - 1
            return idade
        
    else: idade = idade
    return idade


if __name__=="__main__":
    main()