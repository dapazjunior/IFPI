def main():
    """Lê dia e mês e imprime o signo correspondente."""

    #Entrada de dados
    dia = int(input())
    mes = int(input())

    #Processamento
    signo = verificar_signo(dia, mes)

    #Saída de dados
    if signo == None:
        print("Data inválida")
    else:
        print(signo)


def verificar_signo(dd, mm):
    """Retorna o signo com base no dia e mês."""

    if ((mm == 3) and (21 <= dd <= 31)) or ((mm == 4) and (1 <= dd <= 19)):
        return "Áries"
    elif ((mm == 4) and (20 <= dd <= 30)) or ((mm == 5) and (1 <= dd <= 20)):
        return "Touro"
    elif ((mm == 5) and (21 <= dd <= 31)) or ((mm == 6) and (1 <= dd <= 21)):
        return "Gêmeos"
    elif ((mm == 6) and (22 <= dd <= 30)) or ((mm == 7) and (1 <= dd <= 22)):
        return "Câncer"
    elif ((mm == 7) and (23 <= dd <= 31)) or ((mm == 8) and (1 <= dd <= 22)):
        return "Leão"
    elif ((mm == 8) and (23 <= dd <= 31)) or ((mm == 9) and (1 <= dd <= 22)):
        return "Virgem"
    elif ((mm == 9) and (23 <= dd <= 30)) or ((mm == 10) and (1 <= dd <= 22)):
        return "Libra"
    elif ((mm == 10) and (23 <= dd <= 31)) or ((mm == 11) and (1 <= dd <= 21)):
        return "Escorpião"
    elif ((mm == 11) and (22 <= dd <= 30)) or ((mm == 12) and (1 <= dd <= 21)):
        return "Sagitário"
    elif ((mm == 12) and (22 <= dd <= 31)) or ((mm == 1) and (1 <= dd <= 19)):
        return "Capricórnio"
    elif ((mm == 1) and (20 <= dd <= 31)) or ((mm == 2) and (1 <= dd <= 18)):
        return "Aquário"
    elif ((mm == 2) and (19 <= dd <= 29)) or ((mm == 3) and (1 <= dd <= 20)):
        return "Peixes"
    else:
        return None


if __name__ == "__main__":
    main()