# Questão 10
def main():
    for serie in range(1, 5):
        print(f"\nSérie {serie}:")
        a = int(input("Digite o número a:\n>>> "))
        b = int(input("Digite o número b:\n>>> "))
        c = int(input("Digite o número c:\n>>> "))
        d = int(input("Digite o número d:\n>>> "))

        maior = max_dois(max_dois(a, b), max_dois(c, d))
        print(f"O maior número é: {maior}")


def max_dois(n1, n2):
    if n1 >= n2:
        return n1
    else:
        return n2


if __name__ == "__main__":
    main()
