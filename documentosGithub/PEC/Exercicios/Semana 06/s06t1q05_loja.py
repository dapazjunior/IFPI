def main():
    valor = float(input())

    valor_a_vista = desconto(valor, 9)
    valor_em_5 = valor_da_parcela(valor, 5)
    valor_em_10 = valor_da_parcela(acrescimo(valor, 17), 10)

    print(f'{valor_a_vista:.2f}')
    print(f'{valor_em_5:.2f}')
    print(f'{valor_em_10:.2f}')

def desconto(preco, desconto):
    """Calcula e retorna o novo preço do produto tendo como parametros 
    o valor original e o desconto em percetual"""
    
    preco = preco - preco * desconto / 100
    return preco

def valor_da_parcela(preco, n):
    """ Calcula e retorna o valor da parcela tendo como parâmetros o valor do produto
    e o número de parcelas"""

    valor_da_parcela = preco / n
    return valor_da_parcela

def acrescimo(preco, acrescimo):
    """Calcula e retorna o novo preço do produto tendo como parametros 
    o valor original e o desconto em percetual"""
    
    preco = preco + preco * acrescimo / 100
    return preco

if __name__ == "__main__":
    main()