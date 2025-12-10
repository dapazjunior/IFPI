import pdfplumber
import pandas as pd
import re
from time import time

# Caminhos dos arquivos
pdf_objetiva = r"C:\Users\dapaz\OneDrive\Documents\GitHub\IFPI\documentosGithub\dataScience\Aula 01\Resultado_Prova_objetiva_Ampla.pdf"
pdf_titulos = r"C:\Users\dapaz\OneDrive\Documents\GitHub\IFPI\documentosGithub\dataScience\Aula 01\relatorio-amplaConcorrencia-titulos.pdf"

# Funções desejadas
funcoes_desejadas = ["30", "51"]

def extrair_dados(pdf_path, tipo):
    dados = []
    funcao_num = None
    funcao_nome = None
    municipio = None

    regex_funcao = re.compile(r"FUN\w*[:\s]*\s*(\d{1,3})\s*[-–—]\s*(.+)", re.IGNORECASE)
    regex_local = re.compile(r"Local\s+Concorr\w*[:]\s*(.+)", re.IGNORECASE)
    regex_candidato = re.compile(
        r"^\s*\d+\s+(\d+)\s+([A-ZÁÉÍÓÚÃÕÇ\s]+)\s+(\*{3}\.\d{3}\.\d{3}-\*{2})\s+([\d,.]+)\s*$"
    )

    with pdfplumber.open(pdf_path) as pdf:
        total = len(pdf.pages)
        print(f"\n📄 Extraindo dados de {tipo} ({total} páginas)...")
        inicio = time()
        registros = 0

        for i, page in enumerate(pdf.pages, start=1):
            text = page.extract_text()
            if not text:
                continue

            for line in text.split("\n"):
                line = line.strip()

                # Detectar nova função
                fmatch = regex_funcao.search(line)
                if fmatch:
                    numero = fmatch.group(1).strip()
                    nome = fmatch.group(2).strip()
                    if numero in funcoes_desejadas:
                        funcao_num = numero
                        funcao_nome = nome
                        print(f"➡️ Nova função detectada: {funcao_num} - {funcao_nome}")
                    else:
                        funcao_num = None
                        funcao_nome = None
                    municipio = None
                    continue

                # Detectar novo município
                lmatch = regex_local.search(line)
                if lmatch:
                    municipio = lmatch.group(1).strip()
                    continue

                # Detectar candidato (somente se função atual for uma das desejadas)
                cmatch = regex_candidato.match(line)
                if cmatch and funcao_num in funcoes_desejadas and municipio:
                    inscricao = cmatch.group(1).strip()
                    nome = cmatch.group(2).strip()
                    cpf = cmatch.group(3).strip()
                    pontos = cmatch.group(4).replace(",", ".")
                    try:
                        pontos = float(pontos)
                    except:
                        pontos = None
                    dados.append([funcao_num, funcao_nome, municipio, inscricao, nome, cpf, pontos])
                    registros += 1

            if i % 10 == 0 or i == total:
                print(f"  - Página {i}/{total} processada ({registros} registros até agora)")

        fim = time()
        print(f"\n✅ {tipo}: {registros} registros extraídos em {fim - inicio:.1f}s.")
    return pd.DataFrame(dados, columns=["Função_Num", "Função_Nome", "Município", "Inscrição", "Nome", "CPF", "Pontos"])

# Extrair dados
df_obj = extrair_dados(pdf_objetiva, "Prova Objetiva")
df_tit = extrair_dados(pdf_titulos, "Prova de Títulos")

# Renomear colunas
df_obj.rename(columns={"Pontos": "Pontos_Objetiva"}, inplace=True)
df_tit.rename(columns={"Pontos": "Pontos_Titulos"}, inplace=True)

# Unir pelos campos em comum
df_final = pd.merge(df_obj, df_tit, on=["CPF", "Nome", "Função_Num", "Função_Nome", "Município"], how="outer")

# Calcular nota total
df_final["Total"] = df_final[["Pontos_Objetiva", "Pontos_Titulos"]].sum(axis=1, skipna=True)

# Ordenar
df_final.sort_values(by=["Função_Num", "Município", "Total"], ascending=[True, True, False], inplace=True)

# Salvar
df_final.to_excel("Resultado_Final_Funcoes_30e51.xlsx", index=False)
df_final.to_csv("Resultado_Final_Funcoes_30e51.csv", index=False, sep=";")

print(f"\n🏁 Concluído! Total de {len(df_final)} candidatos nas funções 30 e 51.")
print("📂 Arquivos gerados: Resultado_Final_Funcoes_30e51.xlsx e .csv")
