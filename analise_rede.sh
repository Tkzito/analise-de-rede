#!/bin/bash

# Define o diretório dos arquivos
DIR="/home/user/Analise-de-Rede_e_Relatorio/resultados_rede"
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

