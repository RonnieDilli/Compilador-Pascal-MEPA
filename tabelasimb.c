#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"
#include "tabelasimb.h"
#include "pilha.h"

int procuraElementoTab(TabelaSimbT *tab, char *id) {
  int i;
  // debug_print("tab->num_elementos = %d\n", tab->num_elementos);
  if (tab == NULL) {
    return -1;
  }
  else if (tab->num_elementos > 0) {
    i = (tab->num_elementos - 1);
    while (i >= 0) {
      // debug_print("tab->elemento[%d].id = %s\n", i, tab->elemento[i].id);
      if (strcmp(tab->elemento[i].id, id) == 0) {
        break;
      }
      i--;
    }
    // debug_print("i = [%d]\n", i);
    return i;
  }
  return -1;
}

int insereElementoTab(TabelaSimbT *tab, char *str) {
  if (tab->num_elementos + 1 > MAX_TAB) {
    fprintf(stderr, "ERRO: *** Tamanho da tabela de simbolos dinamica excedido!\n");
    exit (-1);
  }
  else {
    strcpy(tab->elemento[tab->num_elementos].id, str);
    tab->num_elementos = tab->num_elementos + 1;
  }
  return 0;
}

int atribuiTiposTab(TabelaSimbT *tab, TipoT tipo, int n) {
  int i;
  if (tab == NULL) {
    return -1;
  }
  else if (tab->num_elementos - n >= 0) {
    debug_print("[else if] tab->num_elementos = %d , n = %d\n", tab->num_elementos, n);
    for (i = 0; i < n; i++) {
      tab->elemento[tab->num_elementos-i-1].tipo = tipo;
      debug_print("[for] tab->elemento[tab->num_elementos-%d-1].tipo = %d\n", i, tab->elemento[tab->num_elementos-i-1].tipo);
    }
    // debug_print("i = [%d]\n", i);
    return i;
  }
  return -1;
}

int imprimeElementosTab(TabelaSimbT *tab) {
  int i;
  printf("[%s] tab->num_elementos = %d\n", __func__, tab->num_elementos); // #DEBUG
  if (tab == NULL) {
    return -1;
  }
  else if (tab->num_elementos > 0) {
    i = (tab->num_elementos - 1);
    while (i >= 0)  {
      printf("[%s] tab->elemento[%d].id= %s  tipo(cod)= %d\n", __func__, i, tab->elemento[i].id, tab->elemento[i].tipo);
      i--;
    }
  }
  return 0;
}
