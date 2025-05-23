def main():
    num = int(input())

    num_invertido = inverte_numero(num)

    print(f'{num_invertido}')


def inverte_numero(numero):
    u = numero // 1000
    d = (numero % 1000) // 100
    c = ((numero % 1000) % 100) // 10
    um = ((numero % 1000) % 100) % 10

    numero_invertido = um * 1000 + c * 100 + d * 10 + u
    return numero_invertido

main()