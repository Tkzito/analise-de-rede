import subprocess
import datetime

def run_script():
    # Define o caminho para o script de shell
    shell_script_path = '/home/user/Analise-de-Rede_e_Relatorio/analise_rede.sh'

    try:
        # Executa o script de shell
        result = subprocess.run([shell_script_path], check=True, text=True, capture_output=True)
        # Imprime a saída do script de shell
        print("Saída do script de shell:")
        print(result.stdout)
        # Imprime qualquer erro do script de shell
        if result.stderr:
            print("Erros do script de shell:")
            print(result.stderr)

    except subprocess.CalledProcessError as e:
        print(f"Erro ao executar o script de shell: {e}")

def main():
    # Chama a função para executar o script
    run_script()

if __name__ == "__main__":
    main()

