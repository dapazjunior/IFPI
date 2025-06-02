def main():
    # Entrada de dados
    nascimento = int(input("Digite sua data de nascimento no formato DDMMAAAA: "))
    
    # Processamento
    dia, mes, _ = separar_data(nascimento)
    meu_signo = signo(dia, mes)
    horoscopo_de_hoje = horoscopo(meu_signo)

    # Saída de dados
    print(horoscopo_de_hoje)


def separar_data(dma):
    # Separa a data em dia, mês e ano a partir do inteiro DDMMAAAA
    a = dma % 10000
    dma //= 10000
    m = dma % 100
    dma //= 100
    d = dma
    return d, m, a


def signo(dia, mes):
    # Retorna o signo baseado no dia e mês fornecidos
    if mes == 3:
        return "Peixes" if dia < 21 else "Áries"
    if mes == 4:
        return "Áries" if dia < 21 else "Touro"
    if mes == 5:
        return "Touro" if dia < 21 else "Gêmeos"
    if mes == 6:
        return "Gêmeos" if dia < 21 else "Câncer"
    if mes == 7:
        return "Câncer" if dia < 23 else "Leão"
    if mes == 8:
        return "Leão" if dia < 23 else "Virgem"
    if mes == 9:
        return "Virgem" if dia < 23 else "Libra"
    if mes == 10:
        return "Libra" if dia < 23 else "Escorpião"
    if mes == 11:
        return "Escorpião" if dia < 22 else "Sagitário"
    if mes == 12:
        return "Sagitário" if dia < 22 else "Capricórnio"
    if mes == 1:
        return "Capricórnio" if dia < 21 else "Aquário"
    if mes == 2:
        return "Aquário" if dia < 20 else "Peixes"


def horoscopo(signo_desejado):
    # Busca e retorna o horóscopo do signo desejado na web
    import urllib.request

    signo_formatado = remover_acentos(signo_desejado).lower()
    minha_url = "https://www.horoscopovirtual.com.br/horoscopo/" + signo_formatado

    requisicao = urllib.request.Request(
        url=minha_url,
        headers={"User-Agent": "Mozilla/5.0"}
    )

    resposta = urllib.request.urlopen(requisicao)
    pagina = resposta.read().decode("utf-8")  # Corrigido para "utf-8"

    marcador_inicio = '<p class="text-pred">'
    marcador_final = '</p>'

    inicio = pagina.find(marcador_inicio) + len(marcador_inicio)
    final = pagina.find(marcador_final, inicio)

    return signo_desejado + ': ' + pagina[inicio:final]


def remover_acentos(texto):
    # Remove acentos de um texto
    from unicodedata import normalize
    return normalize('NFKD', texto).encode('ASCII', 'ignore').decode('ASCII')


if __name__ == "__main__":
    main()
