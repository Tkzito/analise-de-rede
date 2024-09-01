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

# Função principal
main() {
    executar_analise
}

main

