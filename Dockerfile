# Use uma imagem base do Python
FROM python:3.12

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos do projeto para o contêiner
COPY . /app

# Instale as dependências
RUN pip install --no-cache-dir -r requirements.txt

# Crie o diretório de logs
RUN mkdir -p /app/logs

# Exponha a porta que o Flask vai usar
EXPOSE 8000

# Comando para iniciar o servidor Flask
CMD ["python", "app.py"]

