#!/usr/bin/env bash

## Tetador do Compilador Pascal->MEPA por Ronnie Dilli
## Version 0.1 - 2013/12/10

if [ -x 'compilador' ]; then
  TESTADOS=0
  APROVADOS=0

  SAVEIFS=$IFS
  IFS=$(echo -en "\n\b")
  for f in PgmasTeste/E*
  do
    ((TESTADOS += 1))
    echo "----"
    ./compilador $f/pgma.pas  >/dev/null # 2>/dev/null
    ret=$?
    if [ $ret == 0 ]; then
      diff $f/MEPA MEPA
      if [ $? == 0 ]; then
        ((APROVADOS += 1))
        echo ">> [OK] $f <<"
      else
        echo "^^ Diferencas entre '$f/MEPA' e 'MEPA'  ^^"
      fi
    else
      echo "Erro ($ret) ao compilar o arquivo: '$f'"
    fi
  done
  IFS=$SAVEIFS
  echo -e "\n--------------------\n[$APROVADOS/$TESTADOS] Programas compilados corretamente!"
else
  echo "Erro: *** compilador nao encontrado!"
  exit 1
fi
