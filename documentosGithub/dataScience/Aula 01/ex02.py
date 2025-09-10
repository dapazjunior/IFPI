def main():
    num1 = int(input("Digite o primeiro número: "))
    num2 = int(input("Digite o segundo número: "))

    soma = somar(num1, num2)
    produto = multiplicar(num1, num2)
    maior = max(num1, num2)

    print(f'Soma: {soma}')
    print(f'Produto: {produto}')
    print(f'Maior: {maior}')


def somar(n1, n2):
    return n1 + n2


def multiplicar(n1, n2):
    return n1 * n2


if __name__ == "__main__":
    main()