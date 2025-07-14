def main():
    cidades = carrega_cidades()  # carrega os dados do arquivo .csv

    dia, mes = solicitar_data()  # solicita o dia e o mês do aniversário
    
    cidades_aniv = verificar_aniversariantes(dia, mes, cidades)  # filtra as cidades que fazem aniversário nesse dia

    # exibe a lista com a data formatada
    print(f"CIDADES QUE FAZEM ANIVERSÁRIO EM {dia} DE {mes_escrito(mes)}:")
    for cidade in cidades_aniv:
        print(f'{cidade[0]}({cidade[1]})')  # cidade[0] = nome, cidade[1] = UF


def solicitar_data():
    # lê o dia e o mês digitados pelo usuário
    dia = int(input())
    mes = int(input())

    return dia, mes  # retorna os dois valores


def verificar_aniversariantes(dia, mes, cidades):
    aniversariantes = []  # lista que vai guardar as cidades que batem com a data
    for cidade in cidades:
        if dia == cidade[3] and mes == cidade[4]:  # cidade[3] = dia, cidade[4] = mês
            aniversariantes.append((cidade[2], cidade[0], cidade[3], cidade[4]))  # nome, UF, dia, mês
    return aniversariantes


def mes_escrito(mes):
    # converte número do mês para nome
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
            # separa os dados da linha
            uf, ibge, nome, dia, mes, pop = linha.split(';')
            # transforma os dados para o formato correto e adiciona na lista
            resultado.append((uf, int(ibge), nome, int(dia), int(mes), int(pop)))
    arquivo.close()
    return resultado


if __name__ == "__main__":
    main()
