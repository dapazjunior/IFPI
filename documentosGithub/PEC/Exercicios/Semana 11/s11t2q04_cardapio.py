def main():
    total = 0

    while True:
        # mostra o cardápio e lê o pedido
        opcao = input("CÓDIGO  PRODUTO         PREÇO (R$)\n" \
        "H       Hamburger       5,50\n" \
        "C       Cheeseburger    6,80\n" \
        "M       Misto Quente    4,50\n" \
        "A       Americano       7,00\n" \
        "Q       Queijo Prato    4,00\n" \
        "X       PARA TOTAL DA CONTA\n").strip().lower()
        
        if opcao == 'x':  # se for x, termina
            break

        total += valor(opcao)  # soma o valor do item ao total
    
    print(f'{total:.2f}')  # mostra o total da conta


def valor(opcao):
    # retorna o preço de acordo com o item
    if opcao == 'h':
        return 5.5
    elif opcao == 'c':
        return 6.8
    elif opcao == 'm':
        return 4.5
    elif opcao == 'a':
        return 7
    elif opcao == 'q':
        return 4


if __name__ == "__main__":
    main()
