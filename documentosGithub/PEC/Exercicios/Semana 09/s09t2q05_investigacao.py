def main():
    """Faz 5 perguntas e classifica a participação na investigação."""
    # Entrada de dados
    resposta1 = input().strip().lower()
    resposta2 = input().strip().lower()
    resposta3 = input().strip().lower()
    resposta4 = input().strip().lower()
    resposta5 = input().strip().lower()

    # Processamento e saída de dados
    parecer = investigar(resposta1, resposta2, resposta3, resposta4, resposta5)

    print(parecer)


def investigar(r1, r2, r3, r4, r5):
    """Conta respostas 's' e classifica como Inocente, Suspeito, Cúmplice ou Assassino."""
    cont = 0

    cont += respondeu_sim(r1)
    cont += respondeu_sim(r2)
    cont += respondeu_sim(r3)
    cont += respondeu_sim(r4)
    cont += respondeu_sim(r5)

    return verificar_respostas(cont)


def respondeu_sim(r):
    """Retorna 1 se a resposta for 's', senão retorna 0."""
    if r == "s":
        return 1
    else:
        return 0


def verificar_respostas(cont):
    """Classifica a pessoa com base na quantidade de respostas 's'."""
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
