def main():
    while True:
        nota = float(input())  # lê a nota

        if eh_valida(nota):  # verifica se tá entre 0 e 10
            conceito = verificar_conceito(nota)  # pega o conceito
            print(conceito)
            break
        else:
            print('Nota inválida.')  # se for fora do intervalo


def verificar_conceito(nota):
    # retorna o conceito com base na nota
    if nota >= 8.5:
        return 'A'
    elif nota >= 7:
        return 'B'
    elif nota >= 5:
        return 'C'
    elif nota >= 4:
        return 'D'
    else:
        return 'E'
    

def eh_valida(nota):
    return nota >= 0 and nota <= 10  # retorna True se a nota estiver no intervalo válido


if __name__ == "__main__":
    main()
