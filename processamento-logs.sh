#!/bin/bash

DIRETORIO_MYAPP_LOGS="/home/thiago/coding_scripts/myapp/logs"
ARQUIVO_DIR="/home/thiago/coding_scripts/myapp/logs-processados"
TEMP_DIR="/home/thiago/coding_scripts/myapp/logs-temp"

mkdir -p $ARQUIVO_DIR
mkdir -p $TEMP_DIR

#IFS= internal Field Separator
#A opção -r impede a interpretação caracteres especiais e -d '' indica que delimitador é o caractere nulo


# Procurando diretorio com extensão .log no MYAPP
find $DIRETORIO_MYAPP_LOGS -name "*.log" -print0 | while IFS= read -r -d '' arquivo; do
    grep "ERROR" "$arquivo" > "${arquivo}.filtrado"
    grep "SENSITIVE_DATA" "$arquivo" >> "${arquivo}.filtrado"

    # Trocando as palavras sensiveis pro REDACTED  - logs frontend
    sed -i 's/Failed login attempt for username: .*/Failed login attempt for username: REDACTED/g' "${arquivo}.filtrado"
    sed -i 's/User password changed for user ID .*/User password changed for user ID REDACTED/g' "${arquivo}.filtrado"
    sed -i 's/User session initiated with token: .*/User session initiated with token: REDACTED/g' "${arquivo}.filtrado"


    # Trocando as palavras sensiveis pro REDACTED  - logs backend
    sed -i 's/User password is .*/User password is REDACTED/g' "${arquivo}.filtrado"
    sed -i 's/User password reset request with token .*/User password reset request with token REDACTED/g' "${arquivo}.filtrado"
    sed -i 's/API key leaked: .*/API key leaked: REDACTED/g' "${arquivo}.filtrado"
    sed -i 's/User credit card last four digits: .*/User credit card last four digits: REDACTED/g' "${arquivo}.filtrado"
    
    # Ordenando arquivo
    sort "${arquivo}.filtrado" -o "${arquivo}.filtrado"

    # Removendo duplicatas
    uniq "${arquivo}.filtrado" > "${arquivo}.unico"

    num_palavras=$(wc -w < "${arquivo}.unico")
    num_linhas=$(wc -l < "${arquivo}.unico")
    nome_arquivo=$(basename "${arquivo}.unico")


    echo "Arquivo: $nome_arquivo" >> "${ARQUIVO_DIR}/log_stats_$(date +%F).txt"
    echo "Numero de linhas: $num_linhas" >> "${ARQUIVO_DIR}/log_stats_$(date +%F).txt"
    echo "Numero de palavras: $num_palavras" >> "${ARQUIVO_DIR}/log_stats_$(date +%F).txt"
    echo "-----------------------------------------" >> "${ARQUIVO_DIR}/log_stats_$(date +%F).txt"

    cat "${arquivo}.unico" >> "${ARQUIVO_DIR}/logs_combinados_$(date +%F).log"

    # Verificando a condição frontend ou backend do nome do arquivo
    if [[ "$nome_arquivo" == *frontend* ]]; then
	sed 's/^/[FRONTEND] /' "${arquivo}.unico" >> "${ARQUIVO_DIR}/logs_combinados_$(date +%F).log"
    elif [[ "$nome_arquivo" == *backend* ]]; then 
    	sed 's/^/[BACKEND] /' "${arquivo}.unico" >> "${ARQUIVO_DIR}/logs_combinados_$(date +%F).log"	    
     else
	cat "${arquivo}.unico" >> "${ARQUIVO_DIR}/logs_combinados_$(date +%F).log"
fi

done

#ordenando o arquivo do logs combinados
sort -k2 "${ARQUIVO_DIR}/logs_combinados_$(date +%F).log" -o "${ARQUIVO_DIR}/logs_combinados_$(date +%F).log"

# movendo o arquivos logs combinados e log stats pra dir temp dir
mv "${ARQUIVO_DIR}/logs_combinados_$(date +%F).log" "$TEMP_DIR/"
mv "${ARQUIVO_DIR}/log_stats_$(date +%F).txt" "$TEMP_DIR/"
tar -czf "${ARQUIVO_DIR}/logs$(date +%F).tar.gz" -C "$TEMP_DIR" .

rm -r "$TEMP_DIR"


CONTADOR=1

while [ $CONTADOR -le 5 ]; do
	echo "Contador: $CONTADOR"
	((CONTADOR++))
done
