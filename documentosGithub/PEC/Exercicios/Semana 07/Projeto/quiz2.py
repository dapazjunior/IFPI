def main():
    """Realiza um quiz de perguntas e exibe a pontuação final."""

    #Início da contagem de pontos
    pontuacao = 0

    pontuacao += pergunta1()
    pontuacao += pergunta2()
    pontuacao += pergunta3()
    pontuacao += pergunta4()
    pontuacao += pergunta5()
    pontuacao += pergunta6()
    pontuacao += pergunta7()
    pontuacao += pergunta8()


    if pontuacao == 0:
        print("\nVocê não acertou questões!")
    elif pontuacao == 1:
        print("\nVocê acertou 1 questão!")
    else:
        print(f"\nVocê acertou {pontuacao} questões!")

    print("Obrigado por participar!")


def perguntar(questao, resposta_correta):
    """Recebe uma pergunta (string) e a resposta correta (string).
    Solicita a resposta do usuário, verifica se está correta, 
    imprime mensagem apropriada e retorna 1 para acerto ou 0 para erro."""

    resposta = input(questao).strip().lower()

    if resposta == resposta_correta:
        print("Parabéns! Acertou! =D\n")
        return 1
    else:
        print("Não foi dessa vez =(\n")
        return 0


def pergunta1():
    questao = "Quantas Copas do Mundo o Brasil ganhou? (por extenso)\na - Três\nb - Quatro\nc - Cinco\nR: "
    certa = "c"
    return perguntar(questao, certa)


def pergunta2():
    questao = "Em que ano o Brasil ganhou sua primeira Copa do Mundo?\na - 1958\nb - 1970\nc - 1994\nR: "
    certa = "a"
    return perguntar(questao, certa)


def pergunta3():
    questao = "Quem é o maior artilheiro da história da Seleção Brasileira?\na - Ronaldo Fenômeno\nb - Pelé\nc - Neymar\nR: "
    certa = "c"
    return perguntar(questao, certa)


def pergunta4():
    questao = "Quantas vezes o Brasil sediou a Copa do Mundo?\na - Uma vez\nb - Duas vezes\nc - Três vezes\nR: "
    certa = "b"
    return perguntar(questao, certa)

def pergunta5():
    questao = "Qual jogador brasileiro marcou três gols em uma final de Copa do Mundo?\na - Zico\nb - Pelé\nc - Romário\nR: "
    certa = "b"
    return perguntar(questao, certa)


def pergunta6():
    questao = "Contra qual país o Brasil jogou a final da Copa do Mundo de 2002?\na - Alemanha\nb - Argentina\nc - França\nR: "
    certa = "a"
    return perguntar(questao, certa)


def pergunta7():
    questao = "Quem era o técnico da Seleção Brasileira na conquista da Copa de 1994?\na - Telê Santana\nb - Zagallo\nc - Carlos Alberto Parreira\nR: "
    certa = "c"
    return perguntar(questao, certa)


def pergunta8():
    questao = "Qual desses jogadores NÃO jogou a Copa de 2002?\na - Rivaldo\nb - Ronaldinho Gaúcho\nc - Kaká\nR: "
    certa = "c"
    return perguntar(questao, certa)


if __name__ == "__main__":
    main()
