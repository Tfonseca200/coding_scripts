#!/bin/bash

LOG_DIR="LOG_SYSTEM_THI"
ARQ="monitoramento_sistema_thCompany"
ARQ_AUTH="monitoramento_logAuth"
WEB_SITE="https://github.com/Tfonseca200"


function monitorar_logs(){
grep -E "fail()?|failed|Error|unauthorized|danied" /var/log/syslog | awk '{print $1, $2, $3, $4, $5}' > $LOG_DIR/$ARQ

grep -E "fail()?|failed|Error|unauthorized|danied" /var/log/auth.log | awk '{print $1, $2, $3, $4, $5}' > $LOG_DIR/$ARQ_AUTH
}


function verificar_conectividade_internet(){
	if ping -c 2 8.8.8.8 > /dev/null; then
		echo "$(date): Conexão ativa " >> $LOG_DIR/$ARQ
	else
		echo "$(date): Sem conexão " >> $LOG_DIR/$ARQ
	fi
}

function vericar_conexao_webSite(){
	local URL=$1

	server=$(curl -s --head "$URL" | grep -i "^Server:" | awk '{print $2}')

	if [ -n "$server" ]; then
		echo "$(date): Conexão com o servidor do $server bem sucedida ." > $LOG_DIR/$ARQ
	else
		echo "$(date): Falha a conectar com o servidor em $URL" > $LOG_DIR/$ARQ
	fi

}

function monitorar_all_sistema(){
	monitorar_logs
	verificar_conectividade_internet
	vericar_conexao_webSite "$WEB_SITE"
}

monitorar_all_sistema

