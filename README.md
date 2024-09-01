Análise de Rede, Automação, Relatórios e Planilhas
Descrição
Este projeto é uma solução para análise de rede e automação de relatórios. Ele inclui scripts para análise de dados de rede, geração de relatórios e criação de planilhas. O projeto é desenvolvido em Python com Flask para a parte web e utiliza Docker para facilitar a configuração e o gerenciamento do ambiente.

Estrutura do Projeto
app.py: Aplicação Flask que serve a interface web.
analise_rede.sh: Script para realizar a análise de rede.
docker-compose.yml: Configuração do Docker Compose para orquestrar contêineres.
Dockerfile: Configuração do Docker para construir a imagem do contêiner.
requirements.txt: Lista de dependências Python necessárias para o projeto.
resultados_rede/: Diretório contendo scripts e resultados da análise de rede.
templates/: Diretório contendo templates HTML para a aplicação Flask.
logs/: Diretório para armazenar logs gerados pela aplicação.
update_report.sh: Script para atualizar o relatório.
gerar_relatorio.sh: Script para gerar relatórios baseados na análise de rede.
Requisitos
Docker
Docker Compose
Python 3.12
Dependências listadas em requirements.txt
Configuração
Clone o Repositório

bash
Copiar código
git clone git@github.com:Tkzito/analise-de-rede.git
cd analise-de-rede
Configuração do Docker

Certifique-se de que Docker e Docker Compose estão instalados e funcionando. Em seguida, execute o Docker Compose para configurar o ambiente:

bash
Copiar código
docker-compose up --build
Isso criará e iniciará o contêiner do Docker conforme definido no docker-compose.yml.

Executar Scripts

Para executar o script de análise de rede e criar relatórios, use:

bash
Copiar código
./resultados_rede/gerar_relatorio.sh
Para atualizar o relatório, use:

bash
Copiar código
./resultados_rede/update_report.sh
Uso
A aplicação Flask estará disponível em http://localhost:8001. Acesse esta URL no seu navegador para interagir com a aplicação e visualizar os relatórios gerados.

Contribuindo
Se você quiser contribuir para este projeto, siga estes passos:

Fork o Repositório: Crie um fork deste repositório para a sua própria conta.
Clone seu Fork: Clone o repositório forked para a sua máquina local.
Crie uma Branch: Crie uma nova branch para suas alterações.
Faça as Alterações: Faça as alterações desejadas e faça commit delas.
Enviando um Pull Request: Envie um pull request para o repositório original com uma descrição das suas alterações.
Licença
Este projeto está licenciado sob a Licença MIT - consulte o arquivo LICENSE para obter detalhes.

Contato
Se você tiver dúvidas ou sugestões, entre em contato através do e-mail: tkzito84@gmail.com.

