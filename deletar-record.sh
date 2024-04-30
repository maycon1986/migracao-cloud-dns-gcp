#!/bin/bash

ZONE_NAME="dominio1-com"

# Lista todos os registros e armazena os nomes dos registros em um arquivo temporário
gcloud dns record-sets list --zone=$ZONE_NAME --format="value(name, type)" | awk '$2 != "NS"'| awk '$2 != "SOA"' > records.txt

# Lê cada nome e tipo de registro do arquivo e os deleta
while IFS= read -r RECORD; do
  RECORD_NAME=$(echo "$RECORD" | awk '{print $1}')
  RECORD_TYPE=$(echo "$RECORD" | awk '{print $2}')
  gcloud dns record-sets delete "$RECORD_NAME" --type="$RECORD_TYPE" --zone=$ZONE_NAME --quiet
done < records.txt

# Remove o arquivo temporário
rm records.txt
