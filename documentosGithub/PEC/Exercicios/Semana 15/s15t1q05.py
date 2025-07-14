def main():
    cidades = carrega_cidades()

    mes = int(input())
    qtd = int(input())
    
    cidades_maiores = verificar_maiores(qtd, cidades)

    print(f"CIDADES COM MAIS DE {qtd} HABITANTES E ANIVERSÁRIO EM {mes_escrito(mes)}:")
    for cidade in cidades_maiores:
        if mes == cidade[4]:
            mes_minusculo = mes_escrito(cidade[4]).lower()
            print(f'{cidade[2]}({cidade[0]}) tem {cidade[5]} habitantes e faz aniversário em {cidade[3]} de {mes_minusculo}.')

def solicitar_data():
    dia = int(input())
    mes = int(input())

    return dia, mes


def verificar_maiores(pop, cidades):
    maiores = []
    for cidade in cidades:
        if cidade[5] > pop:
            maiores.append(cidade)
    return maiores


def mes_escrito(mes):
    if mes == 1:
        return "JANEIRO"
    elif mes == 2:
        return "FEVEREIRO"
    elif mes == 3:
        return "MARÇO"
    elif mes == 4:
        return "ABRIL"
    elif mes == 5:
        return "MAIO"
    elif mes == 6:
        return "JUNHO"
    elif mes == 7:
        return "JULHO"
    elif mes == 8:
        return "AGOSTO"
    elif mes == 9:
        return "SETEMBRO"
    elif mes == 10:
        return "OUTUBRO"
    elif mes == 11:
        return "NOVEMBRO"
    elif mes == 12:
        return "DEZEMBRO"
    else:
        return "MÊS INVÁLIDO"
    

def carrega_cidades():
    resultado = []
    with open("cidades.csv", 'r', encoding='utf-8') as arquivo:
        for linha in arquivo:
            uf, ibge, nome, dia, mes, pop = linha.split(';')
            resultado.append(
                (uf, int(ibge), nome, int(dia), int(mes), int(pop))
            )
    arquivo.close()
    return resultado


if __name__ == "__main__":
    main()