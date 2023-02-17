#!/usr/bin/env python3
# 2023_02_17_17_51_21


#Bibliotecas
import pandas as pd
import json
from flatten_json import flatten
import os

#Abre arquivo json
arquivojson = os.environ["arquivo"]
with open(arquivojson) as f:
	chat = json.load (f)

#Planifica o json
plano = [flatten(d) for d in chat]
df1 = pd.DataFrame(plano)

#Renomeia as colunas
limpa = df1.rename(columns={"author_id": "Autor", "author_images_0_url": "Foto", "author_name": "Nome", "message": "Mensagem", "timestamp": "Timestamp", "time_text": "Tempo"})

#Seleciona apenas algumas colunas
limpa = limpa[['Autor', 'Foto', 'Nome', 'Mensagem', 'Timestamp', 'Tempo']]

#Insere novas colunas com valores variáveis
limpa.insert(0, 'Nome_da_live', os.environ["titulo"])
limpa.insert(0, 'Data_da_live', os.environ["data"])
limpa.insert(0, 'ID_da_live', os.environ["ide"])
limpa.insert(0, 'Canal', os.environ["canal"])
limpa.insert(10, 'Datatime', 'Canal')
limpa['Datatime'] = pd.to_datetime(limpa['Timestamp'], unit='us', utc=True)
limpa['Datatime'] = limpa['Datatime'].dt.tz_convert('America/Sao_Paulo').dt.strftime('%Y-%m-%d %H:%M:%S ')

#Exporta para csv
nomedoarquivo = os.environ["ide"]+".csv"
limpa.to_csv(nomedoarquivo)
