def main():
    cidades = carrega_cidades()  # carrega a lista de cidades do arquivo

    qtd = int(input())  # lê a população mínima desejada

    cidades_maiores = verificar_maiores(qtd, cidades)  # filtra as cidades com população maior

    # imprime as cidades encontradas
    print(f"CIDADES COM MAIS DE {qtd} HABITANTES:")
    for cidade in cidades_maiores:
        # cidade[1] = IBGE, cidade[2] = nome, cidade[0] = UF, cidade[5] = população
        print(f'IBGE: {cidade[1]} - {cidade[2]}({cidade[0]}) - POPULAÇÃO: {cidade[5]}')


def solicitar_data():
    dia = int(input())
    mes = int(input())
    return dia, mes


# verifica quais cidades têm população maior que o valor informado
def verificar_maiores(pop, cidades):
    maiores = []
    for cidade in cidades:
        if cidade[5] > pop:
            maiores.append(cidade)
    return maiores


# lê o arquivo cidades.csv e carrega os dados das cidades
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
