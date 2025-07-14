def main():
    cidades = carrega_cidades()

    qtd = int(input())

    cidades_maiores = verificar_maiores(qtd, cidades)

    print(f"CIDADES COM MAIS DE {qtd} HABITANTES:")
    for cidade in cidades_maiores:
        print(f'IBGE: {cidade[1]} - {cidade[2]}({cidade[0]}) - POPULAÇÃO: {cidade[5]}')

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