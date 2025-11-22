============================================================
              SCRIPTS BASH (MONITORAMENTO E LOGS)
============================================================

Este repositório contém dois scripts Bash , projetados para 
automatizar o monitoramento de sistema e o processamento de logs, 
otimizando a manutenção de ambientes de servidor.

Sistema: Ubunto server
Acesso: SSH

------------------------------------------------------------
1. monitoramento_sistema.sh - MONITORAMENTO EM TEMPO REAL
------------------------------------------------------------

Este script consolida várias verificações vitais do sistema em uma 
função central, 'monitorar_all_sistema()'.

- FUNÇÕES INCLUÍDAS:
  1. monitorar_logs              : Acompanha a atividade nos arquivos de log.
  2. verificar_conectividade_internet: Testa a conectividade via PING no DNS 8.8.8.8.
  3. vericar_conexao_webSite     : Usa CURL para checar o status de um website (via $WEB_SITE).
  4. monitorar_disco             : Relata o uso do disco usando DF e AWK.
  5. monitorar_hardware          : Relata o uso da memória (hardware) usando FREE e AWK.

- ORQUESTRAÇÃO CENTRAL:
  function monitorar_all_sistema(){
      monitorar_logs
      verificar_conectividade_internet
      vericar_conexao_webSite "$WEB_SITE"
      monitorar_disco
      monitorar_hardware
  }

------------------------------------------------------------
2. processamento-logs.sh - LIMPEZA E ANÁLISE DE LOGS
------------------------------------------------------------

Este script é especializado na normalização e segurança de arquivos de log.

- ETAPAS DE PROCESSAMENTO:
  1. Localização      : Usa FIND para identificar os diretórios e arquivos de log.
  2. Redação (REDACTED) : Usa SED para trocar palavras sensíveis por 'REDACTED'.
  3. Ordenação        : Usa SORT para organizar o conteúdo do arquivo.
  4. Desduplicação    : Usa UNIQ para remover linhas duplicadas.
  5. Classificação    : Usa IF/ELSE para verificar se o log é 'frontend' ou 'backend' com base no nome do arquivo.
