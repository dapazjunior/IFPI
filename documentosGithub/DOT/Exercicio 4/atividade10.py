def main():
    lista = [5, -2, -2, 5, 3, 5, 10, -2, 3, 10, 3, 1]
    resultado = maior_soma_repetidos(lista)
    print(f"Lista: {lista}")
    print(f"Maior soma dos números que se repetem: {resultado}")


def maior_soma_repetidos(lista):
    somados = []
    maior = 0

    for num in lista:
        if num not in somados:
            contador = 0
            for item in lista:
                if item == num:
                    contador += 1
            if contador > 1:
                somados.append(num)
                soma = num * contador
                if soma > maior:
                    maior = soma

    return maior


if __name__ == "__main__":
    main()