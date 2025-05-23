def main():
    """Lê matrícula e notas, calcula média, conceito, situação e exibe tudo."""

    #Entrada de dados
    matricula = input().strip()
    n1 = float(input())
    n2 = float(input())
    n3 = float(input())
    n_ex = float(input())

    #Processamento
    media = calcular_media(n1, n2, n3, n_ex)
    conceito = verificar_conceito(media)
    
    #Saída de dados
    print(matricula)
    print(f'{media:.2f}')
    print(conceito)
    print(verifcar_aprovacao(conceito))


def calcular_media(n1, n2, n3, n4):
    """Calcula a média ponderada das notas n1, n2, n3 e n4."""

    return (n1 + n2 * 2 + n3 * 3 + n4) / 7
    

def verificar_conceito(media):
    """Retorna o conceito com base na média."""

    if media >= 9:
        conceito = "A"
    elif media >= 7.5:
        conceito = "B"
    elif media >= 6:
        conceito = "C"
    elif media >= 4:
        conceito = "D"
    else:
        conceito = "E"    

    return conceito


def verifcar_aprovacao(conceito):
    """Verifica se o conceito é A, B ou C (Aprovado) ou D e E (Reprovado)."""

    if conceito == "A" or conceito == "B" or conceito == "C":
        return "Aprovado"
    else:
        return "Reprovado"


if __name__ == "__main__":
    main()