def main():
    """Classifica um caractere como vogal, consoante, número ou símbolo."""

    #Entrada de dados
    caractere = input().strip()

    #Processamento
    categoria = classificar_caractere(caractere)

    #Saída de dados
    print(categoria)


def classificar_caractere(c):
    """Retorna a categoria do caractere recebido."""
    if eh_vogal(c):
        tipo = "vogal"
    elif eh_consoante(c):
        tipo = "consoante"
    elif eh_numero(c):
        tipo = "número"
    else:
        tipo = "símbolo"
    return tipo


def eh_vogal(caractere):
    """Retorna True se o caractere é vogal."""
    vogais = "aeiou"
    return caractere.lower() in vogais


def eh_consoante(caractere):
    """Retorna True se o caractere é consoante."""
    return "a"<= caractere.lower() <= "z" and not eh_vogal(caractere)


def eh_numero(caractere):
    """Retorna True se o caractere é número."""
    return "0" <= caractere <= "9"


if __name__ == "__main__":
    main()