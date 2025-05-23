def main():
    """Lê um valor em segundos, converte em horas, minutos e segundos, 
    e exibe o resultado no formato hh:mm:ss"""
    tempo = int(input())

    h, tempo = segundos_em_horas(tempo)
    m, s = segundos_em_minutos(tempo)

    print(f'{h}:{m}:{s}')


def segundos_em_horas (segundos):
    """Calcula e retorna a quantidade de horas completas em um tempo em segundos, 
    junto com o restante em segundos"""
    
    h = segundos // (60*60)
    resto = segundos % (60*60)

    return h, resto


def segundos_em_minutos (segundos):
    """Calcula e retorna a quantidade de minutos completos em um tempo em segundos, 
    junto com o restante em segundos"""

    m = segundos // 60
    resto = segundos % 60

    return m, resto


if __name__ == "__main__":
    main()