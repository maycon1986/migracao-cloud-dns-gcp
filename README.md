## 🚀 Neste repositório vamos migrar um servidor de dns para o Cloud DNS do Google. Aqui estão os passos que seguiremos:

| LEMBRETE: O Procedimento abaixo tem que ser realizado após a autenticação no seu projeto GCP |
| :------------------------------------------------------------------------------------------- |

### 1. Faça o upload dos arquivos do tipo BIND para o diretório "dns".
```bash
ls dns 
```
`dominio.com.dns dominio1.com.dns`

### 2. Após realizar o upload, valide os arquivos para remover o "SOA" e o "NS", pois iremos utilizar do Cloud DNS. Execute o script validar-arquivos.sh.
```bash
bash validar-arquivos.sh
```

### 3. A remoção do "SOA" e do "NS" deve ser feita manualmente no arquivo. Repita o passo 2 até obter um resultado como este abaixo.

#### Retorno do comando
Record SOA do arquivo dominio1.com.dns
 
----------------------------------------------------------------
Record NS do arquivo dominio1.com.dns
 
----------------------------------------------------------------
Record SOA do arquivo dominio.com.dns
 
----------------------------------------------------------------
Record NS do arquivo dominio.com.dns
 
----------------------------------------------------------------

### 4. Após validar o arquivo, execute o script "criacao.sh". Na primeira execução do script, ele criará as zonas no Cloud DNS. É possível que apresente um erro informando que a zona não existe; essa mensagem é normal. Ao concluir a execução, verifique se as zonas foram criadas corretamente no painel do Cloud DNS.

```bash
bash criacao.sh
```
#### Retorno do comando 
ERROR: (gcloud.dns.managed-zones.describe) HTTPError 404: The 'parameters.managedZone' resource named 'dominio1-com' does not exist.

Created [https://dns.googleapis.com/dns/v1/projects/dns-externo-abril/managedZones/dominio1-com].

dominio1.com.dns. Zona criado com sucesso

ERROR: (gcloud.dns.managed-zones.describe) HTTPError 404: The 'parameters.managedZone' resource named 'dominio-com' does not exist.

Created [https://dns.googleapis.com/dns/v1/projects/dns-externo-abril/managedZones/dominio-com].

dominio.com.dns. Zona criado com sucesso


### 5. Verifique se as zonas foram criadas corretamente.

```bash
gcloud dns managed-zones list
```
#### Retorno do comando
NAME          DNS_NAME       DESCRIPTION  VISIBILITY

dominio-com   dominio.com.                public

dominio1-com  dominio1.com.               public

### 6. Após a criação das zonas, execute novamente o script "criacao.sh" para realizar a importação dos arquivos .dns do diretório dns para o Cloud DNS..

```bash
bash criacao.sh
```
#### Retorno do comando
dominio1.com zona existente

Iniciando a importação dos record

Imported record-sets from [./dns/dominio1.com.dns] into managed-zone [dominio1-com].

Created [https://dns.googleapis.com/dns/v1/projects/dns-externo-abril/managedZones/dominio1-com/changes/1].

ID  START_TIME                STATUS

1   2024-04-30T11:38:56.191Z  pending

dominio.com zona existente

Iniciando a importação dos record

Imported record-sets from [./dns/dominio.com.dns] into managed-zone [dominio-com].

Created [https://dns.googleapis.com/dns/v1/projects/dns-externo-abril/managedZones/dominio-com/changes/1].

ID  START_TIME                STATUS

1   2024-04-30T11:39:00.647Z  pending


# Removendo as Zonas
### Para remover uma zona, edite o arquivo "deletar-record.sh"
### Altere a variável com o nome da sua zona que deseja remover.
`ZONE_NAME="dominio-com"`
### Feito isso, execute o script "deletar-record.sh"
```bash
bash deletar-record.sh
```
### Após executar o script, os registros da zona serão removidos. Agora basta excluir a zona.
```bash
gcloud dns managed-zones delete dominio-com
```