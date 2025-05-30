def main():
    codigo = int(input())

    print(verifcar_dia(codigo))


def verifcar_dia(num):
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



if __name__=="__main__":
    main()