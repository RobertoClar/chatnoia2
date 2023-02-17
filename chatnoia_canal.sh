#!/bin/bash
# 2023_02_17_17_51_21

: '
Baixa lives de uma lista e atualiza um banco geral

USO:

chatnoia_canal.sh ARROBA_DO_CANAL
'

#Primeiras variáveis, pasta raiz e URL da live
raiz="$PWD"
export raiz

arrobacanal=$1
export arrobacanal

url="https://www.youtube.com/@""$arrobacanal""/streams"
export url


listacanal(){
#Prpara uma lista
yt-dlp --skip-download --print-json "$url" | jq --join-output '.id,"\n"' >> "$arrobacanal".txt
}
listacanal


#Loop com as ide dos vídeos
while read ides
do
./chatnoia.sh "https://www.youtube.com/watch?v=""$ides"
done <"$arrobacanal".txt


python3 chatnoia_junta_csv.py

echo "ACABOU"
