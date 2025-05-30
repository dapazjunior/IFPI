def main():
    #Entrada de dados
    nascimento = int(input("Digite sua data de nascimento no formato DDMMAAAA: "))
    
    #Processamento
    dia, mes, _ = separar_data(nascimento)
    meu_signo = signo(dia, mes)
    horoscopo_de_hoje = horoscopo(meu_signo)

    #Saída de dados
    print(horoscopo_de_hoje)


def separar_data(dma):
    # Extrai os 4 últimos dígitos da data para obter o ano
    a = dma % 10000
    dma //= 10000

    # Extrai os 2 últimos dígitos restantes para obter o mês
    m = dma % 100
    dma //= 100

    # Guarda os dígitos restantes para obter o dia    
    d = dma
    return d, m, a


def signo(dia, mes):
    # Verifica o mês e o dia para determinar o signo correto

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
    # Importa biblioteca para acessar páginas web
    import urllib.request

    # Formata o nome do signo, removendo acentos e colocando em minúsculas
    signo_formatado = remover_acentos(signo_desejado).lower()

    # Monta a URL do horóscopo com o nome do signo
    minha_url = "https://www.horoscopovirtual.com.br/horoscopo/" + signo_formatado

    # Prepara a requisição simulando um navegador (para não ser bloqueado pelo site)
    requisicao = urllib.request.Request(
        url=minha_url,
        headers={"User-Agent": "Mozilla/5.0"}
    )

    # Faz a requisição e abre a página
    resposta = urllib.request.urlopen(requisicao)

    # Lê o conteúdo da página e decodifica usando UTF-8 (corrigido aqui)
    pagina = resposta.read().decode("utf =8")

    # Define os marcadores HTML que delimitam o texto do horóscopo na página
    marcador_inicio = '<p class="text-pred">'
    marcador_final = '</p>'

    # Encontra a posição inicial do texto desejado
    inicio = pagina.find(marcador_inicio) + len(marcador_inicio)

    # Encontra a posição final do texto desejado
    final = pagina.find(marcador_final, inicio)

    # Retorna o signo junto com o texto do horóscopo extraído da página
    return signo_desejado + ': ' + pagina[inicio:final]


def remover_acentos(texto):
    # Importa função para normalizar texto
    from unicodedata import normalize

    # Remove acentos e caracteres especiais, deixando apenas letras básicas
    return normalize('NFKD', texto).encode('ASCII', 'ignore').decode('ASCII')


# Verifica se o código está sendo executado diretamente (e não importado)
if __name__ == "__main__":
    main()