def main():
    temp_f = float(input("Digite a temperatura em Fahreinheit\n>>> "))

    temp_c = celcius(temp_f)

    print(f"A temperatura {temp_f} F corresponde a {temp_c} °C.")


def celcius(temp):
    return ((temp - 32)/9)*5


if __name__=="__main__":
    main()