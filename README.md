Visão Geral
Este projeto fornece uma aplicação web para executar e gerenciar análises de rede e gerar relatórios a partir dos resultados. A aplicação é construída com Flask e utiliza um único script para realizar a análise de rede e gerar relatórios em Markdown. A aplicação também permite a conversão desses relatórios para o formato Excel.

Instalação
Pré-requisitos
Python 3.8 ou superior
Flask
arp-scan deve estar instalado e disponível no PATH do sistema.
Passos de Instalação
Clone o repositório:

bash
Copiar código
git clone <URL_DO_REPOSITORIO>
cd analise-de-rede
Instale as dependências:

bash
Copiar código
pip install -r requisitos.txt
Certifique-se de que o arp-scan está instalado:

bash
Copiar código
sudo apt-get install arp-scan
Conceda permissões de execução ao script:

bash
Copiar código
chmod +x analise_rede.sh
Inicie a aplicação Flask:

bash
Copiar código
python3 app.py
Estrutura do Projeto
graphql
Copiar código
analise-de-rede/
│
├── analise_rede.sh           # Script para análise de rede e geração de relatórios
├── app.py                    # Aplicação Flask principal
├── resultados_rede/          # Diretório onde são armazenados os resultados e relatórios
│   ├── relatorio_YYYYMMDD_HHMMSS.md  # Relatórios gerados em Markdown
│   ├── relatorio_YYYYMMDD_HHMMSS.xlsx # Relatórios convertidos para Excel
│   ├── scan_YYYYMMDD_HHMMSS.txt      # Arquivos de resultado do scan de rede
│   ├── update_report.log      # Arquivo de log para atualizações de relatórios
│
└── templates/                # Diretório de templates HTML para a aplicação Flask
    ├── ajuda.html            # Página de ajuda
    ├── exibir_relatorio.html # Página para exibir o conteúdo de um relatório
    ├── index.html            # Página principal
    └── lista_relatorios.html # Página para listar os relatórios disponíveis
Scripts e Funcionalidades
analise_rede.sh
Descrição: Realiza a análise de rede usando arp-scan, gera um relatório em Markdown com detalhes sobre a rede e dispositivos detectados, e salva os resultados. Este é o único script necessário para realizar toda a análise e gerar os relatórios.
Funcionalidades:
Detecta a interface de rede ativa e a faixa de IP.
Executa o scan da rede e gera um arquivo de resultados.
Gera um relatório detalhado com as estatísticas do scan e informações adicionais sobre a rede.
Uso da Aplicação
Acesse a aplicação:

Abra seu navegador e vá para http://127.0.0.1:5000.
Gerar Relatórios:

No painel principal, clique no botão para gerar relatórios.
A aplicação executará o script analise_rede.sh e atualizará os relatórios.
Visualizar Relatórios:

Navegue até a seção de relatórios para visualizar os resultados gerados.
Relatórios podem ser baixados e visualizados diretamente no navegador.
Converter Relatórios para Excel:

Clique no link para converter um relatório Markdown em Excel.
Endpoints da API
/
Método: GET
Descrição: Página principal da aplicação.
/gerar_relatorio
Método: POST
Descrição: Executa o script analise_rede.sh para gerar relatórios.
/download/<filename>
Método: GET
Descrição: Baixa um arquivo de relatório específico.
/converter_excel/<filename>
Método: GET
Descrição: Converte um arquivo Markdown para Excel e faz o download.
/ajuda
Método: GET
Descrição: Página de ajuda.
/relatorios
Método: GET
Descrição: Lista todos os arquivos de relatórios disponíveis.
/relatorios/<filename>
Método: GET
Descrição: Visualiza um arquivo de relatório específico.
Requisitos e Dependências
Python 3.8+
Flask: pip install Flask
openpyxl: pip install openpyxl
arp-scan: Deve estar instalado e configurado no PATH.
Contribuição
Se você deseja contribuir para este projeto, por favor, siga estes passos:

Faça um fork do repositório.
Crie uma nova branch (git checkout -b minha-nova-feature).
Faça as suas mudanças e faça commit (git commit -am 'Adiciona nova feature').
Envie a sua branch (git push origin minha-nova-feature).
Abra uma pull request.
Licença
Este projeto está licenciado sob a Licença MIT.

#################################################
analise_rede.sh

┌──(tk㉿RodrigoSilveira)-[~/analise-de-rede]
└─$ cat analise_rede.sh
#!/bin/bash

# Define o diretório dos arquivos
DIR="/home/tk/analise-de-rede/resultados_rede"
SCAN_FILE="$DIR/scan_$(date +'%Y%m%d_%H%M%S').txt"

# Detecta a interface de rede ativa
INTERFACE=$(ip link show | grep 'state UP' | awk -F: '{print $2}' | tr -d ' ' | head -n 1)

# Detecta a faixa de IP da rede (substituindo a detecção da faixa de IP para considerar o IP da interface)
NETWORK=$(ip -o -f inet addr show $INTERFACE | awk '{print $4}' | awk -F'/' '{print $1}' | awk -F. '{print $1 "." $2 "." $3 ".0/24"}')

# Executa o scan da rede e salva a saída em um arquivo
echo "Escaneando a faixa de IP: $NETWORK..."
arp-scan --interface=$INTERFACE --localnet > "$SCAN_FILE"

# Verifica se o arquivo de scan foi criado com sucesso
if [ ! -f "$SCAN_FILE" ]; then
    echo "Arquivo de scan não encontrado!"
    exit 1
fi

# Extrai o gateway conectado usando ip route
GATEWAY=$(ip route | grep default | awk '{print $3}')

# Verifica se o gateway foi encontrado
if [ -z "$GATEWAY" ]; then
    echo "Não foi possível identificar o gateway conectado."
    GATEWAY="Desconhecido"
fi

# Gera o relatório
REPORT_FILE="$DIR/relatorio_$(date +'%Y%m%d_%H%M%S').md"

{
    echo "# Relatório de Rede"
    echo ""
    echo "**Data e Hora do Scan:** $(date +'%Y-%m-%d %H:%M')"
    echo ""
    echo "**Gateway Conectado:** $GATEWAY"
    echo ""
    echo "**Nome da Rede WiFi:** $(iwgetid -r)"
    echo ""
    echo "**Tipo de Conexão:** Wireless"
    echo ""
    echo "**Rede Escaneada:** $NETWORK"
    echo ""
    echo "## Dispositivos Encontrados"
    echo ""
    echo "| IP Address     | MAC Address          | Vendor                    | Hostname           |"
    echo "|----------------|-----------------------|---------------------------|--------------------|"

    awk -F'\t' '/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ {printf "| %-15s | %-17s | %-25s | %-18s |\n", $1, $2, $3, $4}' "$SCAN_FILE" | sort | uniq

    echo ""
    echo "## Estatísticas do Scan"
    echo ""

    HOSTS_SCANNED=256
    HOSTS_RESPONDED=$(grep -o '^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' "$SCAN_FILE" | grep -v '0.0.0.0' | sort | uniq | wc -l)

    # Captura o número de pacotes recebidos e descartados e o tempo total
    RECEIVED_PACKETS=$(grep 'packets received by filter' "$SCAN_FILE" | awk '{print $1}')
    DROPPED_PACKETS=$(grep 'packets dropped by kernel' "$SCAN_FILE" | awk '{print $1}')
    TOTAL_TIME=$(grep 'Ending arp-scan' "$SCAN_FILE" | awk -F'scanned in ' '{print $2}' | awk '{print $1}')

    echo "- **Total de Hosts Escaneados:** $HOSTS_SCANNED"
    echo "- **Hosts Respondidos:** $HOSTS_RESPONDED"
    echo "- **Tempo Total:** $TOTAL_TIME segundos"
    echo ""
    echo "## Detalhes Adicionais"
    echo ""
    echo "- **Scan Tipo:** ARP Scan"
    echo "- **Método:** arp-scan --interface=$INTERFACE --localnet"
    echo "- **Número de Pacotes Recebidos:** $RECEIVED_PACKETS"
    echo "- **Número de Pacotes Dropped:** $DROPPED_PACKETS"
    echo ""
    echo "## Notas"
    echo ""
    echo "- **Vendor:** O campo 'Vendor' é obtido com base no prefixo MAC e pode não estar disponível para todos os dispositivos."
    echo "- **Hostname:** Pode não ser possível obter o nome do host para todos os dispositivos na rede."
    echo ""
    echo "**Observações:** Se precisar de mais informações sobre algum dispositivo específico ou sobre o relatório, consulte a documentação do \`arp-scan\` ou entre em contato com o administrador da rede."
} > "$REPORT_FILE"

# Verifica se o relatório foi gerado com sucesso
if [ ! -f "$REPORT_FILE" ]; then
    echo "Relatório não gerado!"
    exit 1
fi

echo "Relatório gerado em: $REPORT_FILE"

###############################################################################################
app.py
┌──(tk㉿RodrigoSilveira)-[~/analise-de-rede]
└─$ cat app.py
from flask import Flask, render_template, send_file, request, redirect, url_for, abort
import os
import logging
import subprocess
from datetime import datetime

app = Flask(__name__)

# Configurando o logger
logging.basicConfig(level=logging.INFO)

# Caminho absoluto para o script de análise de rede
Caminho_Script_Analise = '/home/tk/analise-de-rede/analise_rede.sh'

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/gerar_relatorio', methods=['POST'])
def gerar_relatorio():
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

    # Redirecionar para a lista de relatórios
    return redirect(url_for('lista_relatorios'))

@app.route('/download/<filename>')
def download_report(filename):
    report_file = os.path.join('/home/tk/analise-de-rede/resultados_rede', filename)

    if not os.path.exists(report_file):
        logging.error(f"Arquivo {report_file} não encontrado.")
        return "Erro: Arquivo de relatório não encontrado.", 404

    return send_file(report_file, as_attachment=True)

@app.route('/converter_excel/<filename>')
def converter_excel(filename):
    if not filename.endswith('.md'):
        abort(404)

    caminho_arquivo = os.path.join('/home/tk/analise-de-rede/resultados_rede', filename)

    if not os.path.exists(caminho_arquivo):
        abort(404)

    # Ler o conteúdo do arquivo .md
    with open(caminho_arquivo, 'r') as f:
        conteudo = f.read()

    # Processar o conteúdo e converter para Excel
    from openpyxl import Workbook
    workbook = Workbook()
    sheet = workbook.active

    # Adicionar o conteúdo do arquivo .md ao Excel
    for linha in conteudo.splitlines():
        sheet.append([linha])

    excel_file = os.path.join('/home/tk/analise-de-rede/resultados_rede', filename.replace('.md', '.xlsx'))
    workbook.save(excel_file)

    return send_file(excel_file, as_attachment=True)

@app.route('/ajuda')
def ajuda():
    return render_template('ajuda.html')

@app.route('/relatorios')
def lista_relatorios():
    # Listar todos os arquivos .md no diretório de relatórios
    diretorio_relatorios = '/home/tk/analise-de-rede/resultados_rede'
    arquivos_md = [f for f in os.listdir(diretorio_relatorios) if f.endswith('.md')]
    return render_template('lista_relatorios.html', arquivos=arquivos_md)

@app.route('/relatorios/<filename>')
def relatorio(filename):
    # Verificar se o arquivo solicitado é um .md e se existe
    if not filename.endswith('.md'):
        abort(404)

    caminho_arquivo = os.path.join('/home/tk/analise-de-rede/resultados_rede', filename)

    if not os.path.exists(caminho_arquivo):
        abort(404)

    with open(caminho_arquivo, 'r') as f:
        conteudo = f.read()

    return render_template('exibir_relatorio.html', conteudo=conteudo, filename=filename)

if __name__ == '__main__':
    app.run(debug=True)

#####################################################################################################
ajuda.html
┌──(tk㉿RodrigoSilveira)-[~/analise-de-rede/templates]
└─$ cat ajuda.html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajuda e Contato</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 800px; margin: 0 auto; text-align: center; }
        .button { padding: 10px 15px; font-size: 16px; cursor: pointer; background-color: #4CAF50; color: white; border: none; border-radius: 5px; }
        .button:hover { background-color: #45a049; }
        .content { text-align: left; margin: 20px; }
        a { color: #4CAF50; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Ajuda e Contato</h1>
        <div class="content">
            <h2>Sobre a Página de Relatório</h2>
            <p>A página de relatório exibe uma visão geral dos arquivos encontrados no diretório de resultados da análise de rede. Para cada arquivo, a página mostra o nome, data, hora e conteúdo. Você pode atualizar o relatório clicando no botão "Atualizar Relatório" para refletir as mudanças mais recentes nos dados. Também é possível visualizar o conteúdo dos arquivos em um formato fácil de ler.</p>

            <h2>Status da Ferramenta</h2>
            <p>Esta ferramenta está em desenvolvimento e é executada totalmente local neste equipamento. O código fonte é livre e pode ser aprimorado por qualquer pessoa. No entanto, como desenvolvedor individual, não me responsabilizo pela utilização ou pelas modificações feitas na ferramenta.</p>
            <p>Para obter atualizações com foco no que tenho em mente para o sistema ou mais informações, você pode entrar em contato comigo. Lembrando que, por se tratar de código livre, não há obrigação da minha parte em dar sequência ao desenvolvimento.</p>

            <h2>Geração de Relatórios</h2>
            <p>Para obter informações sobre outras redes, basta se conectar e gerar o relatório através da ferramenta.</p>

            <h2>Contato</h2>
            <p>Você pode entrar em contato comigo através dos seguintes meios:</p>
            <p><a href="mailto:tkzito84@gmail.com">Enviar e-mail</a></p>
            <p><a href="https://wa.me/5513996351877" target="_blank">Enviar mensagem no WhatsApp</a></p>
        </div>
        <a href="/" class="button">Voltar para o Relatório</a>
    </div>
</body>
</html>

#############################################################################################################

exibir_relatorio.html
┌──(tk㉿RodrigoSilveira)-[~/analise-de-rede/templates]
└─$ cat exibir_relatorio.html
<!doctype html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Exibir Relatório</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
        .container {
            max-width: 800px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="text-center">Relatório: {{ filename }}</h1>
        <pre>{{ conteudo }}</pre>
        <a href="{{ url_for('download_report', filename=filename) }}" class="btn btn-warning mt-4">Baixar Relatório</a>
        <a href="{{ url_for('converter_excel', filename=filename) }}" class="btn btn-success mt-4">Converter para Excel</a>
        <a href="{{ url_for('lista_relatorios') }}" class="btn btn-primary mt-4">Voltar para Lista de Relatórios</a>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

#######################################################################################################

index.html

┌──(tk㉿RodrigoSilveira)-[~/analise-de-rede/templates]
└─$ cat index.html
<!doctype html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Início - Sistema de Relatórios de Rede Automatizado</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
        .container {
            max-width: 800px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="text-center">Bem-vindo ao Sistema de Relatórios de Rede Automatizado</h1>
        <p>Ferramenta encontra-se em constante evoludão e adaptação, ela estará disponivel em meu github, para obter o link entre em contato na pagina Ajuda</p>
        <p>Este sistema permite gerar, visualizar e converter relatórios de análise de rede. Utilize os seguintes recursos:</p>

        <ul class="list-group">
            <li class="list-group-item">
                <a href="{{ url_for('lista_relatorios') }}">Ver relatórios</a> - Visualize todos os relatórios gerados e acesse cada um deles.
            </li>
            <li class="list-group-item">
                <a href="{{ url_for('ajuda') }}">Ajuda</a> - Obtenha mais informações sobre como utilizar o sistema.
            </li>
        </ul>
        <form action="{{ url_for('gerar_relatorio') }}" method="post" class="mt-4">
            <button type="submit" class="btn btn-primary btn-lg btn-block">Gerar Relatório</button>
        </form>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

#####################################################################################################

lista_relatorios.html
┌──(tk㉿RodrigoSilveira)-[~/analise-de-rede/templates]
└─$ cat lista_relatorios.html
<!doctype html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lista de Relatórios</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 20px;
        }
        .container {
            max-width: 800px;
        }
        .report-list {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="text-center">Lista de Relatórios</h1>
        <ul class="list-group report-list">
            {% for arquivo in arquivos %}
                <li class="list-group-item">
                    <h5>{{ arquivo }}</h5>
                    <a href="{{ url_for('relatorio', filename=arquivo) }}" class="btn btn-info btn-sm">Ver Relatório</a>
                    <a href="{{ url_for('converter_excel', filename=arquivo) }}" class="btn btn-success btn-sm">Converter para Excel</a>
                </li>
            {% endfor %}
        </ul>
        <a href="{{ url_for('index') }}" class="btn btn-primary mt-4">Voltar para Início</a>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
