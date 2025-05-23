def main():
    """Lê um nome e estado civil. Se casado, lê o nome do conjuge, junta e conta caracteres."""

    #Entrada de dados
    nome = input().strip()
    estado_civil = int(input())

    if eh_casado(estado_civil):
        nome = nome + input().strip()
    
    #Processamento
    num_caracteres = contar_caracteres(nome)
    
    #Saída de dados
    print(num_caracteres)


def contar_caracteres(texto):
    """Retorna a quantidade de caracteres da string 'texto'."""

    return len(texto)


def eh_casado(valor):
    """Recebe um valor inteiro e retorna True se o valor corresponde a 'casado'."""
    if valor == 1:
        return True
    else:
        return False


if __name__ == "__main__":
    main()