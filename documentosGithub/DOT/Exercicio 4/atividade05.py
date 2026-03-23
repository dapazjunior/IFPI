def main():
    lista = [1, 2, 3]
    resultado = soma_cumulativa(lista)
    print(f"Lista original: {lista}")
    print(f"Soma cumulativa: {resultado}")


def soma_cumulativa(lista):
    cumulativa = []
    soma = 0

    for num in lista:
        soma += num
        cumulativa.append(soma)

    return cumulativa


if __name__ == "__main__":
    main()