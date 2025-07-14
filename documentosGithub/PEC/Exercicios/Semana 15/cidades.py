def carrega_cidades():
    resultado = []
    with open(r'c:\Users\dapaz\OneDrive\Documents\GitHub\IFPI\documentosGithub\PEC\Exercicios\Semana 15\cidades.csv', 'r', encoding='utf-8') as arquivo:
        for linha in arquivo:
            uf, ibge, nome, dia, mes, pop = linha.split(';')
            resultado.append(
                (uf, int(ibge), nome, int(dia), int(mes), int(pop))
            )
    arquivo.close()
    return resultado


cidades = carrega_cidades()
print(cidades[:3] + cidades[-2:])



