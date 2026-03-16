import random


MESES = [
    "Janeiro", "Fevereiro", "Março", "Abril",
    "Maio", "Junho", "Julho", "Agosto",
    "Setembro", "Outubro", "Novembro", "Dezembro"
]


def main():
    qtd_meses = 12

    temperaturas = grava_lista(qtd_meses)

    media = calcular_media(temperaturas)
    meses_acima = meses_acima_da_media(temperaturas, media)

    print(f"Temperaturas por mês:")
    for i in range(qtd_meses):
        print(f"  {MESES[i]}: {temperaturas[i]:.1f}°C")

    print(f"\na) Média anual: {media:.2f}°C")

    print(f"\nb) Meses acima da média:")
    for mes in meses_acima:
        print(f"   {mes}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(round(random.uniform(20, 40), 1))

    return lista


def calcular_media(temperaturas):
    soma = 0

    for temp in temperaturas:
        soma += temp

    return soma / len(temperaturas)


def meses_acima_da_media(temperaturas, media):
    resultado = []

    for i in range(len(temperaturas)):
        if temperaturas[i] > media:
            resultado.append(MESES[i])

    return resultado


if __name__ == "__main__":
    main()