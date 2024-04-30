#!/bin/bash
#
# Nome do Script: validar-arquivos.sh
# Descrição: Verificando a existencia do record SOA e NS
# Autor: Maycon Carvalho
# Data: 17/04/2024
# Versão: 1.0


# Lista dos DNS do cliente para migrar
ls ./dns > dnsfiles.txt

exec <  ./dnsfiles.txt
while read -r DNSFILE; do

    echo "Record SOA do arquivo ${DNSFILE}"
    echo " "
    for i in {1..7}
    do
        cat ./dns/${DNSFILE} | awk '$'${i}' == "SOA"'
    done
    echo "----------------------------------------------------------------"

    echo "Record NS do arquivo ${DNSFILE}"
    echo " "
    for i in {1..5}
    do
        cat ./dns/${DNSFILE} | awk '$'${i}' == "NS"'
    done
    echo "----------------------------------------------------------------"
done

rm -rf ./dnsfiles.txt