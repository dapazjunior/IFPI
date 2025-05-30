def main():
    resposta1 = input().strip().lower()
    resposta2 = input().strip().lower()
    resposta3 = input().strip().lower()
    resposta4 = input().strip().lower()
    resposta5 = input().strip().lower()

    parecer = investigar(resposta1, resposta2, resposta3, resposta4, resposta5)

    print(parecer)


def investigar(r1, r2, r3, r4, r5):
    cont = 0

    cont += respondeu_sim(r1)
    cont += respondeu_sim(r2)
    cont += respondeu_sim(r3)
    cont += respondeu_sim(r4)
    cont += respondeu_sim(r5)

    return verifcar_respostas(cont)


def respondeu_sim(r):
    if r == "s":
        return 1
    else:
        return 0


def verifcar_respostas(cont):
    if cont == 5:
        return "Assassino"
    elif 3 <= cont < 5:
        return "Cúmplice"
    elif cont == 2:
        return "Suspeito"
    else:
        return "Inocente"


if __name__ == "__main__":
    main()