#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"
#include "tabelasimb.h"
#include "pilha.h"

int procuraSimboloTab(TabelaSimbT *tab, char *id) {
  int i;
  // debug_print("tab->num_simbolos = %d\n", tab->num_simbolos);
  if (tab == NULL) {
    return -1;
  }
  else if (tab->num_simbolos > 0) {
    i = (tab->num_simbolos - 1);
    while (i >= 0) {
      // debug_print("tab->simbolo[%d].id = %s\n", i, tab->simbolo[i].id);
      if (strcmp(tab->simbolo[i].id, id) == 0) {
        break;
      }
      i--;
    }
    // debug_print("i = [%d]\n", i);
    return i;
  }
  return -1;
}

int insereSimboloTab(TabelaSimbT *tab, char *id, CategoriaT categoria, int nivel_lexico) {
  if (tab->num_simbolos + 1 > MAX_TAB) {
    fprintf(stderr, "ERRO: *** Tamanho da tabela de simbolos dinamica excedido!\n");
    exit (-1);
  }
  else {
    strcpy(tab->simbolo[tab->num_simbolos].id, id);   /* #TODO Fazer verificacao de erros */
    tab->simbolo[tab->num_simbolos].categoria = categoria;
    tab->simbolo[tab->num_simbolos].nivel_lexico = nivel_lexico;
    tab->num_simbolos = tab->num_simbolos + 1;
  }
  return tab->num_simbolos-1;
}

int atribuiTipoSimbTab(TabelaSimbT *tab, char *id, TipoT tipo) {
  int posicao_simbolo;
  CategoriaT categoria;
  if (tab == NULL) {
    return -1;
  }
  else {
    posicao_simbolo = procuraSimboloTab(tab, id);
    if (posicao_simbolo >= 0) {
      categoria = tab->simbolo[posicao_simbolo].categoria;
      debug_print("[else-if] categoria = %d\n", categoria);
      if (categoria == FUN || categoria == PF || categoria == VS) {
        tab->simbolo[posicao_simbolo].tipo = tipo;
        debug_print("[else-if-if] tab->simbolo[%d].tipo = %d\n", posicao_simbolo, tab->simbolo[posicao_simbolo].tipo);
        return 0;
      }
    }
  }
  return -1;
}

int atribuiTiposTab(TabelaSimbT *tab, TipoT tipo, int n) {
  int i;
  if (tab == NULL) {
    return -1;
  }
  else if (tab->num_simbolos - n >= 0) {
    debug_print("[else if] tab->num_simbolos = %d , n = %d\n", tab->num_simbolos, n);
    for (i = 0; i < n; i++) {
      tab->simbolo[tab->num_simbolos-i-1].tipo = tipo;    /* #TODO Usar funcao atribuiTipoSimbTab (fica mais modular) */
      debug_print("[for] tab->simbolo[tab->num_simbolos-%d-1].tipo = %d\n", i, tab->simbolo[tab->num_simbolos-i-1].tipo);
    }
    // debug_print("i = [%d]\n", i);
    return i;
  }
  return -1;
}

int imprimeTabSimbolos(TabelaSimbT *tab) {
  int i;
  printf("[%s] tab->num_simbolos = %d\n", __func__, tab->num_simbolos); // #DEBUG
  if (tab == NULL) {
    return -1;
  }
  else if (tab->num_simbolos > 0) {
    i = (tab->num_simbolos - 1);
    while (i >= 0)  {
      printf("[%s] tab->simbolo[%2d].id= %-5s  tipo(cod)= %d categoria= %d nivel_lexico,deslocamento=(%d,%d)\n", __func__, i, tab->simbolo[i].id, tab->simbolo[i].tipo, tab->simbolo[i].categoria, tab->simbolo[i].nivel_lexico, tab->simbolo[i].deslocamento);
      i--;
    }
  }
  return 0;
}
