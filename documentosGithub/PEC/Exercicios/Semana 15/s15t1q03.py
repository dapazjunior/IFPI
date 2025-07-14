def main():
    cidades = carrega_cidades()

    dia, mes = solicitar_data()
    
    cidades_aniv = verificar_aniversariantes(dia, mes, cidades)

    print(f"CIDADES QUE FAZEM ANIVERSÁRIO EM {dia} DE {mes_escrito(mes)}:")
    for cidade in cidades_aniv:
        print(f'{cidade[0]}({cidade[1]})')

def solicitar_data():
    dia = int(input())
    mes = int(input())

    return dia, mes


def verificar_aniversariantes(dia, mes, cidades):
    aniversariantes = []
    for cidade in cidades:
        if dia == cidade[3] and mes == cidade[4]:
            aniversariantes.append((cidade[2], cidade[0], cidade[3], cidade[4]))
    return aniversariantes


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