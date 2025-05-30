def main():
    data = input().strip()
   
    d, m, a = separar_data(data)

    print(eh_valida(d, m, a))


def eh_valida(dia, mes, ano):
    if mes < 1 or mes > 12:
        return False
    
    if mes == 1 or mes == 3 or mes == 5 or mes == 7 or mes == 8 or mes == 10 or mes == 12:
        return 0 < dia <= 31

    if mes == 4 or mes == 6 or mes == 9 or mes == 11:
        return 0 < dia <= 30
    
    if mes == 2:
        if eh_bissexto(ano):
            return 0 < dia <= 29
        else:
            return 0 < dia <= 28


def eh_bissexto(ano):
    if ano % 400 == 0:
        return True
    
    if ano % 100 == 0:
        return False
    
    if ano % 4 == 0:
        return True
    

def separar_data(data):
    dia = int(data[0:2])
    mes = int(data[2:4])
    ano = int(data[4:8])

    return dia, mes, ano


if __name__ == "__main__":
    main()