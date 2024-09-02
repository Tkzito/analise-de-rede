from flask import Flask, render_template, send_file, request, redirect, url_for, abort
import os
import logging
<<<<<<< HEAD
from openpyxl import Workbook
import subprocess
=======
import subprocess
from datetime import datetime
>>>>>>> 90f4f845 (Atualização - Inicial)

app = Flask(__name__)

# Configurando o logger
logging.basicConfig(level=logging.INFO)

<<<<<<< HEAD
# Caminho absoluto para os scripts
Caminho_Script_Analise = '/home/user/Analise-de-Rede_e_Relatorio/resultados_rede/executar_analise_e_criar_script.sh'
Caminho_Script_Gerar_Relatorio = '/home/user/Analise-de-Rede_e_Relatorio/resultados_rede/gerar_relatorio.sh'
=======
# Caminho absoluto para o script de análise de rede
Caminho_Script_Analise = '/home/tk/analise-de-rede/analise_rede.sh'
>>>>>>> 90f4f845 (Atualização - Inicial)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/gerar_relatorio', methods=['POST'])
def gerar_relatorio():
<<<<<<< HEAD
    # Executar os scripts para gerar relatórios
    try:
        # Atualizar e gerar relatórios
        if os.path.exists(Caminho_Script_Analise) and os.access(Caminho_Script_Analise, os.X_OK):
            subprocess.run([Caminho_Script_Analise], check=True)
        else:
            logging.error(f"Script de análise não encontrado ou não executável: {Caminho_Script_Analise}")
            return "Erro ao executar o script de análise.", 500
        
        if os.path.exists(Caminho_Script_Gerar_Relatorio) and os.access(Caminho_Script_Gerar_Relatorio, os.X_OK):
            subprocess.run([Caminho_Script_Gerar_Relatorio], check=True)
        else:
            logging.error(f"Script de gerar relatório não encontrado ou não executável: {Caminho_Script_Gerar_Relatorio}")
            return "Erro ao executar o script de gerar relatório.", 500

        logging.info("Relatórios gerados com sucesso.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Erro ao executar os scripts: {e}")
        return "Erro ao gerar relatórios.", 500
    
=======
    # Executar o script de análise
    try:
        if os.path.exists(Caminho_Script_Analise) and os.access(Caminho_Script_Analise, os.X_OK):
            logging.info(f"Executando o script de análise: {Caminho_Script_Analise}")
            result = subprocess.run([Caminho_Script_Analise], check=True, capture_output=True, text=True)
            logging.info(f"Saída do script de análise: {result.stdout}")
            logging.error(f"Erros do script de análise: {result.stderr}")
        else:
            logging.error(f"Script de análise não encontrado ou não executável: {Caminho_Script_Analise}")
            return "Erro ao executar o script de análise.", 500

        logging.info("Relatório gerado com sucesso.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Erro ao executar o script de análise: {e}")
        return "Erro ao gerar relatório.", 500

>>>>>>> 90f4f845 (Atualização - Inicial)
    # Redirecionar para a lista de relatórios
    return redirect(url_for('lista_relatorios'))

@app.route('/download/<filename>')
def download_report(filename):
<<<<<<< HEAD
    report_file = os.path.join('resultados_rede', filename)
=======
    report_file = os.path.join('/home/tk/analise-de-rede/resultados_rede', filename)
>>>>>>> 90f4f845 (Atualização - Inicial)

    if not os.path.exists(report_file):
        logging.error(f"Arquivo {report_file} não encontrado.")
        return "Erro: Arquivo de relatório não encontrado.", 404

    return send_file(report_file, as_attachment=True)

@app.route('/converter_excel/<filename>')
def converter_excel(filename):
    if not filename.endswith('.md'):
        abort(404)

<<<<<<< HEAD
    caminho_arquivo = os.path.join('resultados_rede', filename)
    
=======
    caminho_arquivo = os.path.join('/home/tk/analise-de-rede/resultados_rede', filename)

>>>>>>> 90f4f845 (Atualização - Inicial)
    if not os.path.exists(caminho_arquivo):
        abort(404)

    # Ler o conteúdo do arquivo .md
    with open(caminho_arquivo, 'r') as f:
        conteudo = f.read()
<<<<<<< HEAD
    
    # Processar o conteúdo e converter para Excel
=======

    # Processar o conteúdo e converter para Excel
    from openpyxl import Workbook
>>>>>>> 90f4f845 (Atualização - Inicial)
    workbook = Workbook()
    sheet = workbook.active

    # Adicionar o conteúdo do arquivo .md ao Excel
    for linha in conteudo.splitlines():
        sheet.append([linha])

<<<<<<< HEAD
    excel_file = os.path.join('resultados_rede', filename.replace('.md', '.xlsx'))
=======
    excel_file = os.path.join('/home/tk/analise-de-rede/resultados_rede', filename.replace('.md', '.xlsx'))
>>>>>>> 90f4f845 (Atualização - Inicial)
    workbook.save(excel_file)

    return send_file(excel_file, as_attachment=True)

@app.route('/ajuda')
def ajuda():
    return render_template('ajuda.html')

@app.route('/relatorios')
def lista_relatorios():
    # Listar todos os arquivos .md no diretório de relatórios
<<<<<<< HEAD
    diretorio_relatorios = 'resultados_rede'
=======
    diretorio_relatorios = '/home/tk/analise-de-rede/resultados_rede'
>>>>>>> 90f4f845 (Atualização - Inicial)
    arquivos_md = [f for f in os.listdir(diretorio_relatorios) if f.endswith('.md')]
    return render_template('lista_relatorios.html', arquivos=arquivos_md)

@app.route('/relatorios/<filename>')
def relatorio(filename):
    # Verificar se o arquivo solicitado é um .md e se existe
    if not filename.endswith('.md'):
        abort(404)
<<<<<<< HEAD
    
    caminho_arquivo = os.path.join('resultados_rede', filename)
    
    if not os.path.exists(caminho_arquivo):
        abort(404)
    
    with open(caminho_arquivo, 'r') as f:
        conteudo = f.read()
    
=======

    caminho_arquivo = os.path.join('/home/tk/analise-de-rede/resultados_rede', filename)

    if not os.path.exists(caminho_arquivo):
        abort(404)

    with open(caminho_arquivo, 'r') as f:
        conteudo = f.read()

>>>>>>> 90f4f845 (Atualização - Inicial)
    return render_template('exibir_relatorio.html', conteudo=conteudo, filename=filename)

if __name__ == '__main__':
    app.run(debug=True)

