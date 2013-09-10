#include <stdio.h>
#include <stdlib.h>
#include "tabelasimb.h"

int criaTabela(TabelaSimb *tabela) {
  TabelaSimb *tab;
  tab = malloc (1 * sizeof(TabelaSimb));
  if (tab == NULL)
    return(-1);
  tabela = tab;
  return 0;
};

TabelaSimb * procuraElemento(char *id);

TabelaSimb * insereElemento();

int removeElemento(char *id);