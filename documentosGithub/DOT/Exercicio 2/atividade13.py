import random


def main():
    n = int(input("Quantas vezes o dado será lançado? "))

    resultados = lancar_dado(n)
    print(f"\nResultados: {resultados}")

    ocorrencias = contar_ocorrencias(resultados)

    print("\nOcorrências por face:")
    for face in range(6):
        print(f"  Face {face + 1}: {ocorrencias[face]} vez(es)")


def lancar_dado(n):
    resultados = []

    for _ in range(n):
        resultados.append(random.randint(1, 6))

    return resultados


def contar_ocorrencias(resultados):
    ocorrencias = [0] * 6

    for valor in resultados:
        ocorrencias[valor - 1] += 1

    return ocorrencias


if __name__ == "__main__":
    main()