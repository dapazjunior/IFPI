def main():
    while True:
        nota = float(input())
        if eh_valida(nota):
            conceito = verificar_conceito(nota)
            print(conceito)
            break
        else:
            print('Nota inválida.')


def verificar_conceito(nota):
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
    return nota >= 0 and nota <= 10


if __name__ == "__main__":
    main()