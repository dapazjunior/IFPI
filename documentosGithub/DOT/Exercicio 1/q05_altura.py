def main():
    altura = float(input("Digite a altura (em metros): "))

    print("Digite o sexo:")
    print("1 - Feminino")
    print("2 - Masculino")
    sexo = int(input("Opção: "))

    resultado = peso_ideal(altura, sexo)

    if resultado is None:
        print("Código de sexo inválido. Use 1 para feminino ou 2 para masculino.")
    else:
        print(f"O peso ideal é: {resultado:.2f} kg")


def peso_ideal(altura, sexo):
    if sexo == 1:
        return (62.1 * altura) - 44.7
    elif sexo == 2:
        return (72.7 * altura) - 58
    

if __name__ == "__main__":
    main()
