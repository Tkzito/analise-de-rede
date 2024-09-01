#!/bin/bash

set -e  # Encerra o script se qualquer comando falhar

# Configurações
DIRETORIO_RESULTADOS="/home/user/Analise-de-Rede_e_Relatorio/resultados_rede"
SCRIPT_ANALISE="/home/user/Analise-de-Rede_e_Relatorio/analise_rede.sh"

# Função para executar o script de análise
executar_analise() {
    echo "Executando o script de análise: $SCRIPT_ANALISE..."
    if [ -x "$SCRIPT_ANALISE" ]; then
        "$SCRIPT_ANALISE"
    else
        echo "Erro: $SCRIPT_ANALISE não é executável ou não encontrado." >&2
        exit 1
    fi
}

# Função para criar o script de atualização
criar_script_atualizacao() {
    echo "Criando script de atualização..."
    cat <<EOF > "$DIRETORIO_RESULTADOS/update_report.sh"
#!/bin/bash
/usr/bin/python3 /home/user/Analise-de-Rede_e_Relatorio/app.py
EOF
    chmod +x "$DIRETORIO_RESULTADOS/update_report.sh"
}

# Função principal
main() {
    executar_analise
    criar_script_atualizacao
}

main

