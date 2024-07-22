#!/bin/bash
#
# Nome do Script: script.sh
# Descrição: O script lê os arquivos .dns que estão no diretório 'dns'.
#            Com as informações contidas nos nomes dos arquivos,
#            ele cria a zona no Cloud DNS e realiza a importação dos registros.
#            OBS: Antes de importar, remova o SOA e o NS dos arquivos .dns.
#            O arquivo .dns tem que ser o padrão BIND (Berkeley Internet Name Domain)
# Autor: Maycon Carvalho
# Data: 17/04/2024
# Versão: 1.0

#set -x
set -e

PROJECT_ID="<PROJECT_ID>"
VISIBILITY="public" # or "private".  Default is public.

# Lista dos DNS do cliente para migrar
ls ./dns > dnsfiles.txt

# Criação das Zonas
exec <  ./dnsfiles.txt
while read -r DNSFILE; do

DNS_NAME=$(echo "$DNSFILE" | sed 's/\.dns//g')
ZONE_NAME=$(echo "$DNS_NAME" | sed 's/\./-/g')
MANAGED_ZONE=$(gcloud dns managed-zones describe ${ZONE_NAME} |grep dnsName | awk '{print $2}')

if [ "${MANAGED_ZONE}" != "${DNS_NAME}." ]; then
    gcloud dns --project=$PROJECT_ID \
    managed-zones create $ZONE_NAME \
    --description="" \
    --dns-name="$DNS_NAME" \
    --visibility="$VISIBILITY" \
    --dnssec-state="off"
   echo "${DNSFILE}. Zona criado com sucesso"
else
   echo "${DNS_NAME} zona existente"
   echo "Iniciando a importação dos record"
   gcloud dns record-sets import --zone=${ZONE_NAME} --zone-file-format ./dns/${DNSFILE}
fi;
done

rm -rf ./dnsfiles.txt
