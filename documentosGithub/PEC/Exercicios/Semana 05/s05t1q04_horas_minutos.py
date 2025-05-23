def main():
    minutos = int(input())

    horas, minutos = minutos_em_horas_minutos(minutos)

    print(f'{horas}:{minutos}')


def minutos_em_horas_minutos(min):
    h = min // 60
    min = min % 60
    return h, min

main()