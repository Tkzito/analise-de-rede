#!/bin/bash

# Configurações
PYTHON_PATH="/usr/bin/python3"
APP_PATH="/home/user/Analise-de-Rede_e_Relatorio/app.py"

# Função para verificar se o Python está instalado
verificar_python() {
    if [ ! -x "$PYTHON_PATH" ]; then
        echo "Erro: Python não encontrado no caminho especificado: $PYTHON_PATH" >&2
        exit 1
    fi
}

# Função para verificar se o arquivo app.py existe
verificar_app() {
    if [ ! -f "$APP_PATH" ]; then
        echo "Erro: Arquivo de aplicação não encontrado: $APP_PATH" >&2
        exit 1
    fi
}

# Função para iniciar o aplicativo Flask
iniciar_app() {
    echo "Iniciando o aplicativo Flask: $APP_PATH..."
    "$PYTHON_PATH" "$APP_PATH"
}

# Função principal
main() {
    echo "Iniciando o processo de atualização do relatório..."
    verificar_python
    verificar_app
    iniciar_app
    echo "Aplicativo Flask iniciado com sucesso."
}

main

