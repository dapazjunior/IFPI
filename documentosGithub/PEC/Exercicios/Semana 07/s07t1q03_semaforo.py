def main():
    """Lê uma letra (V, A ou E) e imprime a ação correspondente do semáforo."""
    
    #Entrada de dados
    cor = input().strip().upper()
    
    #Processamento
    mensagem = interpretar_cor(cor)
    
    #Saída de dados
    print(mensagem)


def interpretar_cor(cor):
    """Retorna a mensagem do semáforo de acordo com a cor informada."""
    if cor == "V":
        texto = "Siga"
    elif cor == "A":
        texto = "Atenção"
    elif cor == "E":
        texto = "Pare"
    return texto


if __name__ == "__main__":
    main()