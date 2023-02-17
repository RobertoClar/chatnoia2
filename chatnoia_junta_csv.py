#!/usr/bin/env python3
# 2023_02_17_17_51_21


#Bibliotecas
import os
import glob
import pandas as pd
os.chdir(os.environ["canal"])

extensao = 'csv'
arquivos = [i for i in glob.glob('*.{}'.format(extensao))]

juntos_csv = pd.concat([pd.read_csv(f) for f in arquivos ])
organizado = juntos_csv.sort_values(by=['Timestamp']).drop_duplicates()
combinado = os.environ["arrobacanal"]+".csv"
organizado.to_csv(combinado, index=False)

