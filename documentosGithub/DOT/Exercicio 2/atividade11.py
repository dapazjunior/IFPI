def main():
    lista_nomes = []

    while True:
        print("\n==== MENU ========")
        print("1) Cadastrar nome")
        print("2) Pesquisar nome")
        print("3) Listar todos os nomes")
        print("0) Sair do programa")
        print("------------------")
        escolha = input("Digite sua escolha: ").strip()

        if escolha == "1":
            cadastrar_nome(lista_nomes)
        elif escolha == "2":
            pesquisar_nome(lista_nomes)
        elif escolha == "3":
            listar_nomes(lista_nomes)
        elif escolha == "0":
            print("Saindo do programa...")
            break
        else:
            print("Opção inválida. Tente novamente.")


def cadastrar_nome(lista):
    nome = input("Digite o nome a cadastrar: ").strip()
    lista.append(nome)
    print(f"Nome '{nome}' cadastrado com sucesso!")


def pesquisar_nome(lista):
    nome = input("Digite o nome a pesquisar: ").strip()

    if nome in lista:
        posicao = lista.index(nome)
        print(f"Nome '{nome}' encontrado na posição {posicao}.")
    else:
        print(f"Nome '{nome}' não encontrado na lista.")


def listar_nomes(lista):
    if not lista:
        print("A lista está vazia.")
    else:
        print("Nomes cadastrados:")
        for i, nome in enumerate(lista):
            print(f"  [{i}] {nome}")


if __name__ == "__main__":
    main()