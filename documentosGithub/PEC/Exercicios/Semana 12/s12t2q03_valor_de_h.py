def main():
    num = int(input())

    h = calcular_h(num)

    print(f'{h:.4f}')


def calcular_h(num):
    h = 0

    for i in range(num):
        h += (1 / (i + 1))
    
    return h


if __name__ == "__main__":
    main()