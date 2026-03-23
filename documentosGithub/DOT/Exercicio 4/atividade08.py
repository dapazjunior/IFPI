def main():
    lista = [2.5, 7.5, 10.0, 4.0]
    resultado = mais_proximo_da_media(lista)
    print(f"Lista: {lista}")
    print(f"Valor mais próximo da média: {resultado}")


def mais_proximo_da_media(lista):
    soma = 0

    for num in lista:
        soma += num

    media = soma / len(lista)

    mais_proximo = lista[0]

    for num in lista:
        if abs(num - media) < abs(mais_proximo - media):
            mais_proximo = num

    return mais_proximo


if __name__ == "__main__":
    main()