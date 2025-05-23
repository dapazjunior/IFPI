def main():
    """Lê uma idade em anos terrestres e imprime a idade equivalente em anos espaciais"""

    idade_terra = float(input())
    idade_espaco = converter_idade(idade_terra)
    print(idade_espaco)


def converter_idade(idade):
    """Converte e retorna uma idade terrestre para idade espacial (metade da terrestre)"""

    idade = int(idade * 0.5)
    return idade

if __name__ == "__main__":
    main()
