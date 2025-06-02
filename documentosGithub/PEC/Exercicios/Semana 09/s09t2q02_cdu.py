def main():
    """Lê um número inteiro, verifica se é válido e escreve por extenso as centenas, dezenas e unidades."""
    # Entrada de dados
    numero = int(input())

    # Processamento
    if eh_valido(numero):
        c, d, u = separar_cdu(numero)
        
        texto_centena = monta_texto(c, "centena")
        texto_dezena = monta_texto(d, "dezena")
        texto_unidade = monta_texto(u, "unidade")

        resultado = monta_resultado(texto_centena, texto_dezena, texto_unidade)
    else:
        resultado = "Valor inválido!"
    
    # Saída de dados
    print(resultado)


def eh_valido(num):
    """Verifica se o número está no intervalo válido (0 a 999)."""
    if 0 <= num < 1000:
        return True
    else:
        return False
    

def separar_cdu(num):
    """Separa o número em centenas, dezenas e unidades."""
    c = num // 100
    d = (num % 100) // 10
    u = num % 10
    
    return c, d, u


def monta_texto(quantidade, palavra):
    """Retorna o texto por extenso da quantidade com a palavra correspondente."""
    if quantidade == 1:
        texto = "uma " + palavra
    elif quantidade == 2:
        texto = "duas " + palavra
    elif quantidade == 3:
        texto = "três " + palavra
    elif quantidade == 4:
        texto = "quatro " + palavra
    elif quantidade == 5:
        texto = "cinco " + palavra
    elif quantidade == 6:
        texto = "seis " + palavra
    elif quantidade == 7:
        texto = "sete " + palavra
    elif quantidade == 8:
        texto = "oito " + palavra
    elif quantidade == 9:
        texto = "nove " + palavra
    else:
        texto = ""

    if quantidade >= 2:
        texto += "s"
    
    return texto


def monta_resultado(txt_centena, txt_dezena, txt_unidade):
    """Monta o texto final combinando centenas, dezenas e unidades por extenso."""
    if txt_centena != "" and txt_dezena != "" and txt_unidade != "":
        resultado = txt_centena + ", " + txt_dezena + " e " + txt_unidade
    elif txt_centena != "" and txt_dezena != "":
        resultado = txt_centena + " e " + txt_dezena
    elif txt_centena != "" and txt_unidade != "":
        resultado = txt_centena + " e " + txt_unidade
    elif txt_dezena != "" and txt_unidade != "":
        resultado = txt_dezena + " e " + txt_unidade
    elif txt_centena != "":
        resultado = txt_centena
    elif txt_dezena != "":
        resultado = txt_dezena
    elif txt_unidade != "":
        resultado = txt_unidade
    
    resultado += "."
    
    return resultado


if __name__ == "__main__":
    main()
