from datetime import datetime

class Cofre:
    def __init__(self, senha="12345a", codigo_mestre="9999", estado="fechado", tent_restantes=3):
        self.senha = senha
        self.codigo_mestre = codigo_mestre
        self.estado = estado
        self.tent_restantes = tent_restantes
        self.tent_inicial = tent_restantes
        self.historico_acessos = [] 

    def registrar_tentativa(self, senha_digitada, sucesso):
        data_hora = datetime.now().strftime("%d/%m/%Y, %H:%M:%S") #formatção para hora/data brasileiros
        status = "Sucesso" if sucesso else "Falha" #Salva o status da tentativa feita
        self.historico_acessos.append((data_hora, senha_digitada, status)) #Salva a tentativa no histórico

    def abrir_cofre(self, senha_testada):
        print("\nAbrindo cofre...")

        if self.estado == "bloqueado": #Se "bloqueado", não permite a tentativa
            print("Cofre bloqueado! É necessário o código mestre para desbloquear.")
            return False

        if self.estado == "aberto":
            print("Cofre já está aberto.")
            return True

        if senha_testada == self.senha: #se senha correta, abre o cofre
            self.estado = "aberto"
            self.registrar_tentativa(senha_testada, True)
            print("Cofre aberto com sucesso.")
            return True
        else: 
            self.tent_restantes -= 1 #se senha incorreta, mantém cofre fechado e diminui tentativas
            self.registrar_tentativa(senha_testada, False)
            print(f"Senha incorreta! Tentativas restantes: {self.tent_restantes}")

            if self.tent_restantes == 0:
                self.estado = "bloqueado" #se as tentatias disponíveis zararem, cofre bloqueado
                print("Cofre bloqueado automaticamente!")
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
            print("Cofre já fechado ou bloqueado.")
            return False

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
        if self.estado != "aberto": #verificar se cofre está aberto
            print("Cofre fechado. Não é possível realizar a troca da senha.")
            return False

        if senha_antiga != self.senha:
            print("Senha antiga incorreta. Não é possível realizar a troca.")
            return False

        # Verifica se a nova senha tem pelo menos 6 caracteres
        if len(senha_nova) < 6:
            print("Nova senha inválida! Deve ter pelo menos 6 caracteres.")
            return False

        # Verifica se há pelo menos um número na senha (usando a lógica do aluno)
        numeros = "0123456789"
        tem_numero = False
        for caractere in senha_nova:
            if caractere in numeros:
                tem_numero = True
                break

        if not tem_numero:
            print("Nova senha inválida! Deve conter pelo menos um número.")
            return False

        self.senha = senha_nova
        print("Senha alterada com sucesso.")
        return True

    def desbloquear_cofre(self, codigo_inserido):
        print("\nDesbloqueando cofre...")
        if self.estado != "bloqueado":
            print("Cofre não está bloqueado.")
            return False

        if codigo_inserido == self.codigo_mestre: #verifica se código mestre está correto
            self.estado = "fechado"
            self.tent_restantes = self.tent_inicial
            print("Cofre desbloqueado com sucesso.")
            return True
        else:
            print("Código mestre incorreto. Não foi possível desbloquear.")
            return False

    def exibir_historico(self):
        print("\n>>> HISTÓRICO DE ACESSOS <<<")
        if not self.historico_acessos:
            print("Nenhuma tentativa registrada.")
            return

        for registro in self.historico_acessos:
            data_hora, senha_digitada, status = registro
            print(f"{data_hora} | Senha: {senha_digitada} | Resultado: {status}")


def main():
    cofre1 = Cofre()

    cofre1.abrir_cofre("1235")
    cofre1.abrir_cofre("1233")
    cofre1.abrir_cofre("12345")
    cofre1.desbloquear_cofre('9999')
    cofre1.abrir_cofre("12345a")
    cofre1.exibir_historico()
main()