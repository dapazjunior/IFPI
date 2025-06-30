def main():
    num = int(input())  # lê um número inteiro

    invertido = inverter_numero(num)  # chama a função que inverte o número

    print(invertido)  # mostra o número invertido


def inverter_numero(numero):
    num_invertido = ''  # cria uma string vazia pra ir montando o número ao contrário

    while numero > 0:
        num_invertido += str(numero % 10)  # pega o último dígito e junta
        numero = numero // 10  # tira o último dígito do número original

    return int(num_invertido)  # retorna o número invertido como inteiro


if __name__ == "__main__":
    main()
