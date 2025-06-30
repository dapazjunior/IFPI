def main():
    num = int(input())  # lê quantos termos queremos da série

    h = calcular_h(num)  # calcula a soma da série harmônica

    print(f'{h:.4f}')  # imprime o valor de H com 4 casas decimais


def calcular_h(num):
    h = 0  # começa a soma em 0

    # vai somando 1 dividido pelos números de 1 até num
    for i in range(num):
        h += (1 / (i + 1))  # como i começa em 0, usamos i + 1

    return h  # retorna a soma final


if __name__ == "__main__":
    main()
