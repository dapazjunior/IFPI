class Cofre:
    def __init__(self, senha = "1234", estado = "fechado", tent_restantes = 3):
        self.senha = senha
        self.estado = estado
        self.tent_restantes = tent_restantes
        self.tent_inicial = tent_restantes

    
    def abrir_cofre(self, senhas_testadas):
        print("\nAbrindo cofre...")
        if self.estado == "aberto":
            print("Cofre já está aberto.")
            return True
        else:
            for senha_digitada in senhas_testadas:
                if senha_digitada == self.senha:
                    self.estado = "aberto"
                    print("Cofre aberto com sucesso.")
                    return True
                else:
                    self.tent_restantes -= 1
                    print(f"Senha incorreta! Tentativas restantes: {self.tent_restantes}")
                    if self.tent_restantes == 0:
                        print("Cofre bloqueado!")
                        return False
        
        print("Acesso negado. Tente novamente.")
        return False
    

    def fechar_cofre(self):
        print("\nFechando cofre...")
        if self.estado == "aberto":
            self.estado = "fechado"
            print("Cofre fechado com sucesso.")
            return True
        else:
            print("Cofre já fechado.")
            return True
    

    def resetar_tentativas(self):
        print("\nResetando tentativas...")
        if self.estado == "aberto":
            self.tent_restantes = self.tent_inicial
            print(f"Tentativas restantes: {self.tent_restantes}")
            return True
        else:
            print("Cofre fechado. Abra o cofre para resetar o número de tentativas.")
            return False
         

    def trocar_senha(self, senha_antiga, senha_nova):
        print("\nTrocando senha...")
        if self.estado == "aberto":
            if senha_antiga == self.senha:
                self.senha = senha_nova
                print("Senha alterada com sucesso.")
                return True
            
            else:
                print("Senha antiga incorreta. Não é possível realizar a troca da senha.")
                return False
        else:
            print("Cofre fechado. Não é possível realizar a troca da senha.")
            return False
        
    
def main():
    cofre1 = Cofre()
    cofre2 = Cofre(senha="7896", tent_restantes=5)

    cofre1.abrir_cofre(["1235", "1345", "1234"])
    cofre1.resetar_tentativas()
    cofre1.abrir_cofre(["1235", "1345", "1234"])
    cofre1.fechar_cofre()
    cofre1.trocar_senha("1234", "5678")
    cofre1.abrir_cofre(["1235", "1234", "5678"])
    cofre1.resetar_tentativas()
    cofre1.trocar_senha("1234", "5678")
    cofre1.fechar_cofre()
    cofre1.abrir_cofre(["1234", "5678"])

    cofre2.abrir_cofre(["1234", "2345", "4567", "7896"])
    cofre2.resetar_tentativas()
    cofre2.abrir_cofre(["1234"])
    cofre2.fechar_cofre()
    cofre2.trocar_senha("1234", "5678")
    cofre2.abrir_cofre(["1234", "2345", "7896", "1234"])
    cofre2.resetar_tentativas()
    cofre2.trocar_senha("7896", "246810")
    cofre2.fechar_cofre()
    cofre2.abrir_cofre(["246810"])
main()
