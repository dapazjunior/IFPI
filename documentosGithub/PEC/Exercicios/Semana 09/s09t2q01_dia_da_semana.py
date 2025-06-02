def main():
    """Lê um código numérico e retorna o dia da semana correspondente."""
    # Entrada de dados
    codigo = int(input())

    # Processamento e saída de dados
    print(verifcar_dia(codigo))


def verifcar_dia(num):
    """Retorna o nome do dia da semana de acordo com o código de 1 a 7."""
    if num == 1:
        return "domingo"
    elif num == 2:
        return "segunda-feira"
    elif num == 3:
        return "terça-feira"
    elif num == 4:
        return "quarta-feira"
    elif num == 5:
        return "quinta-feira"
    elif num == 6:
        return "sexta-feira"
    elif num == 7:
        return "sábado"
    else:
        return "valor inválido"


if __name__ == "__main__":
    main()
