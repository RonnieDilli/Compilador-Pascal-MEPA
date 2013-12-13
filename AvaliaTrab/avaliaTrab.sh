#!/usr/bin/env bash

EXEMPLOS="Exemplo5 Exemplo7.1 Exemplo7.2 Exemplo7.3 Exemplo7.4 Exemplo7.5 Exemplo8.10 Exemplo8.12 Exemplo8.5 Exemplo8.6 Exemplo8.7 Exemplo8.8 Exemplo8.9 ExemploErro"


echo "Usage: avaliaTrab.sh <arquivo executavel compilador"
echo "Avaliação: Para os primeiros quatro erros, meio ponto por erro."
echo "Avaliação: Para os demais, um ponto por erro."

desconto=0
aprovados=0
for exemplo in $EXEMPLOS; do
    echo -n $exemplo "... "
    cp $exemplo/pgma.pas .
    cp $exemplo/MEPA MEPA-Res

    $1 pgma.pas > res
    diff MEPA MEPA-Res
    retorno=$?
    if [ $retorno = 0 ]; then
        echo OK
        ((aprovados+=1))
    else
        echo NAO
        ((desconto-=1))
    fi
done

echo "--------"
echo "Desconto  = $desconto"
echo "Aprovados = $aprovados"
