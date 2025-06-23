def main():
    cont = 1
    media = 0

    while True:
        num = int(input())
        if num == 0:
            break
        media = (num + media * (cont - 1))/cont
        cont += 1

    print(f'{media:.2f}')


if __name__ == "__main__":
    main()