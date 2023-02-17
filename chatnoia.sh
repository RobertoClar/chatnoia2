#!/bin/bash
# 2023_02_17_17_51_21


: '
Script para automatizar o salvamento de chat de lives do Youtube

Dependências:
chat_downloader - https://github.com/xenova/chat-downloade
yt-dlp https://github.com/yt-dlp/yt-dlp
python3 pandas - https://pandas.pydata.org

USO:

chatnoia.sh URL_DO_VIDEO
'

#Primeiras variáveis, pasta raiz e URL da live
raiz="$PWD"
export raiz

url=$1
export url

canal=$(yt-dlp "$url" -o '%(uploader)s' --get-filename | iconv -t 'ascii//TRANSLIT')
canal=${canal//[[:blank:]]/}
canal=${canal//-}
export canal

#Pasta do canal
if [ -d "$canal" ]; then
cd "${canal}" || return
echo "Pasta $canal já existe"
else
mkdir -m 777 "${canal}"
cd "${canal}" || return
echo -e "Pasta $canal criada \nComeçando."
fi

#Variáveis do vídeo
titulo=$(yt-dlp --get-title "$url" | iconv -t 'ascii//TRANSLIT')
titulo=$(echo $titulo | sed 's|/||g')
export titulo

ide=$(yt-dlp "$url" -o '%(id)s' --get-filename)
export ide

data=$(yt-dlp "$url" -o '%(upload_date)s' --get-filename)
export data

arquivo=$ide".json"
export arquivo

titulocheio="$data"_"$ide"_"$canal"_"$titulo"
export titulocheio

#Verificação de erros

#Checa se já existe
if [ -f "$ide.csv" ]; then
echo "$ide.csv já existe"
export canal
sleep 5
exit
else 
echo "Começando..."
fi


#Roda o programa principal
chat_downloader "$url" --message_groups "messages superchat" --output "$arquivo"

#Chama a função limpaemotes
source "$raiz"/chatnoia_emotes.sh
echo "Limpando emotes"
cd "$raiz"/"$canal"
limpaemotes

#Limpa o arquivo json e gera um csv
python3 "$raiz"/chatnoia.py
rm -rf "$ide.json"

export canal

echo "Acabou"
