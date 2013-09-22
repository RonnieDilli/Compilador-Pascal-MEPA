#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"
#include "tabelasimb.h"
#include "pilha.h"

int procuraElementoTab(TabelaSimbT *tab, char *id) {
  int i;
    debug_print("tab->num_elementos = %d\n", tab->num_elementos);
  if (tab == NULL) {
    return -1;
  }
  else if (tab->num_elementos > 0) {
    debug_print("[else if] tab->num_elementos = %d\n", tab->num_elementos);
    i = (tab->num_elementos - 1);
    while (i >= 0) {
      debug_print("tab->elemento[%d].id = %s\n", i, tab->elemento[i].id);
      if (strcmp(tab->elemento[i].id, id) == 0) {
        break;
      }
      i--;
    }
    debug_print("i = [%d]\n", i);
    return i;
  }
  return -1;
}

int insereElementosTab(TabelaSimbT *tab, int novos_elem) {
  if (tab->num_elementos + novos_elem > MAX_TAB) {
    fprintf(stderr, "ERRO: *** Tamanho da tabela de simbolos dinamica excedido!\n");
    exit (-1);
  }
  else {
    tab->num_elementos = tab->num_elementos + novos_elem;
  }
  return 0;
}

int imprimeElementosTab(TabelaSimbT *tab, char *id) {
  int i;
  debug_print("tab->num_elementos = %d\n", tab->num_elementos); // #DEBUG
  if (tab == NULL) {
    return -1;
  }
  else if (tab->num_elementos > 0) {
    i = (tab->num_elementos - 1);
    while (i >= 0)  {
      debug_print("[while] tab->elemento[%d].id = %s\n", i, tab->elemento[i].id);
      i--;
    }
  }
  return 0;
}
