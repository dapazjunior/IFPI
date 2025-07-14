def main():
    cidades = carrega_cidades()  # carrega as cidades do arquivo

    mes = int(input())  # lê o mês informado
    qtd = int(input())  # lê a população mínima
    
    cidades_maiores = verificar_maiores(qtd, cidades)  # filtra cidades com população maior

    # imprime a frase de introdução
    print(f"CIDADES COM MAIS DE {qtd} HABITANTES E ANIVERSÁRIO EM {mes_escrito(mes)}:")
    
    for cidade in cidades_maiores:
        if mes == cidade[4]:  # verifica se o mês de aniversário é igual ao informado
            mes_minusculo = mes_escrito(cidade[4]).lower()  # coloca o nome do mês em minúsculo
            # cidade[2] = nome, cidade[0] = UF, cidade[5] = população, cidade[3] = dia
            print(f'{cidade[2]}({cidade[0]}) tem {cidade[5]} habitantes e faz aniversário em {cidade[3]} de {mes_minusculo}.')


# verifica quais cidades têm população maior que a informada
def verificar_maiores(pop, cidades):
    maiores = []
    for cidade in cidades:
        if cidade[5] > pop:
            maiores.append(cidade)
    return maiores


# converte o número do mês para o nome
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


# lê os dados do arquivo cidades.csv
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
