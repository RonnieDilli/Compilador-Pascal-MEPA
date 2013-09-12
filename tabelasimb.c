#include <stdio.h>
#include <stdlib.h>
#include "tabelasimb.h"

int criaTabela(TabelaSimb *tabela) {
  TabelaSimb *tab;
  tab = malloc (1 * sizeof(TabelaSimb));
  if (tab == NULL)
    return(-1);
  // tab.anterior=tab.proximo=NULL;
  // printf("#DEBUG: tab = %d  -  *tab = %d\n", tab, *tab);
  tab=NULL;
  
  /*  TODO: Criar elemento Tabela=NULL, e entao se NULL=> 'tabela vazia', criar 1o elemento... */
  
  elemento *el1;

  el1 = malloc (1 * sizeof(elemento));
  // printf("#DEBUG: tab = %d  -  *tab = %d\n", tab, *tab);
  tab=el1;
  // printf("#DEBUG: tab = %d  -  *tab = %d\n", tab, *tab);
  el1->anterior=el1->proximo=NULL;

  tabela = tab;
  return 0;
};

TabelaSimb * procuraElemento(int nl, char *id);

TabelaSimb * insereElemento();

int removeElemento(char *id);