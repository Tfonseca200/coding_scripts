#! /bin/bash

DIRETORIO_BACKUP="/home/thiago/devops"
NOME_ARQUIVO="backup_$(date +%Y%m%d_%H%M%S).tar.gz"

tar -czf "$NOME_ARQUIVO" "$DIRETORIO_BACKUP"
echo "backup concluido no $DIRETORIO_BACKUP do $NOME_ARQUIVO"
