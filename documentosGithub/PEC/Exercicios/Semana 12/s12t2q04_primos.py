def main():
    num = int(input())

    print(eh_primo(num))


def eh_primo(num):
    multiplos = 0
    
    for c in range(1, num + 1):
        if (num % c == 0):
            multiplos +=  1
    
    return multiplos == 2


if __name__ == "__main__":
    main()