def main():
    total = ler_e_somar()  # chama a função que faz toda a leitura e soma
    print(total)  # mostra o resultado final


def ler_e_somar():
    soma = 0
    num = None  # começa indefinido

    while True:
        num = int(input())  # lê um número
        soma += num  # vai somando
        
        if num == 0:
            break

    return soma  # retorna a soma final


if __name__ == "__main__":
    main()
