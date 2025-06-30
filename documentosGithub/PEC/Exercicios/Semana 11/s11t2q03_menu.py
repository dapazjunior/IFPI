def main():
    while True:
        # mostra as opções e lê a escolha
        opcao = int(input("OPÇÕES:\n1 - SAUDAÇÃO\n2 - BRONCA\n3 - FELICITAÇÃO\n0 - FIM\n"))

        if opcao == 1:
            print("1 - Olá. Como vai?")
        elif opcao == 2:
            print("2 - Vamos estudar mais.")
        elif opcao == 3:
            print("3 - Meus Parabéns!")
        elif opcao == 0:
            print("0 - Fim de serviço.")
            break  # sai do programa
        else:
            print("Opção inválida.")  # se digitar número fora do menu


if __name__ == "__main__":
    main()
