def main():
    """Lê o nome e o sexo do usuário, gera a saudação apropriada
    (Sr. ou Sra.) e exibe o resultado completo na tela"""

    #Entrada de dados
    nome = input().strip()
    sexo = int(input())

    #Processamento
    saudacao = verificar_sexo(sexo)

    #Saídade de Dados
    print(saudacao + nome)


def verificar_sexo(sexo):
    """Retorna a saudação adequada de acordo com o valor de sexo"""

    if sexo == 1:
        return "Ilmo Sr. "
    else:
        return "Ilma Sra. "


if __name__ == "__main__":
    main()