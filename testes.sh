#!/usr/bin/env bash

## Tetador do Compilador Pascal->MEPA por Ronnie Dilli
## Version 0.4 - 2013/12/11
## Sob licensa GPL

if [ -x 'compilador' ]; then
  EX_TESTADOS=0
  APROVADOS=0
  COMPILADOS=0

  SAVEIFS=$IFS
  IFS=$(echo -en "\n\b")
  shopt -s nullglob
  for f in PgmasTeste/Exemplo*
  do
    ((EX_TESTADOS += 1))
    echo "----"
    ./compilador $f/pgma.pas  >/dev/null # 2>/dev/null
    retorno=$?
    if [ $retorno == 0 ]; then
      ((COMPILADOS += 1))
      diff $f/MEPA MEPA
      if [ $? == 0 ]; then
        ((APROVADOS += 1))
        echo ">> [OK]: $f <<"
      else
        echo "^^ Diferencas entre '$f/MEPA' e 'MEPA'  ^^"
      fi
    else
      echo "Erro ($retorno) ao compilar o arquivo: '$f'"
    fi
  done
  if [ $EX_TESTADOS != 0 ]; then
    echo -e "\n--------------------\n[$COMPILADOS/$EX_TESTADOS] Programas compilados."
    echo -e "[$(($EX_TESTADOS - $APROVADOS))] Nao geraram o MEPA esperado!"
  fi

  C_EX_TESTADOS=0
  ERROS_SINTATICOS=0
  ERROS_ESPERADOS=0
  for f in PgmasTeste/ContraExemplo*
  do
    ((C_EX_TESTADOS += 1))
    echo "----"
    ./compilador $f/pgma.pas  >/dev/null # 2>/dev/null
    retorno=$?
    if [ $retorno != 0 ]; then
      ((ERROS_SINTATICOS += 1))
      read ERRO_ESPERADO < $f/ERRO_ESPERADO
      if [ $ERRO_ESPERADO = $retorno ]; then
        ((ERROS_ESPERADOS += 1))
        echo ">> [OK]: O 'erro esperado' ($retorno) foi retornado. <<"
      else
        echo "Erro retornado ($f/ERRO_ESPERADO) diferente do retorno ($retorno)!"
      fi
    else
      echo "Arquivo com ERRO esperado, mas compilado com sucesso: '$f'"
    fi
  done
  IFS=$SAVEIFS
  if [ $C_EX_TESTADOS != 0 ]; then
    echo -e "\n--------------------\n[$ERROS_SINTATICOS/$C_EX_TESTADOS] Contra Exemplos tiveram erro(s) sintatico(s) detectado(s)."
    echo -e "[$(($C_EX_TESTADOS - $ERROS_ESPERADOS))] Nao geraram o ERRO esperado!"
  fi
else
  echo "Erro: *** compilador nao encontrado!"
  exit 1
fi
