#include <stdio.h>
#include <stdlib.h>
#include "tabelasimb.h"

int procuraElementoTab(TabelaSimbT *tab, char *id) {
  int i;
    printf("#DEBUG: [procuraElementoTab] tab->num_elementos = %d\n", tab->num_elementos);
  if (tab == NULL) {
    return -1;
  }
  else if (tab->num_elementos > 0) {
    printf("#DEBUG: [procuraElementoTab, else if] tab->num_elementos = %d\n", tab->num_elementos);
    i = (tab->num_elementos - 1);
    while (i >= 0) {
      printf("#DEBUG: [while] tab->elemento[%d].id = %s\n", i, tab->elemento[i].id);
      if (strcmp(tab->elemento[i].id, id) == 0) {
        break;
      }
      i--;
    }
    printf("#DEBUG: [procuraElementoTab] i = [%d]\n", i);
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
    printf("#DEBUG: [imprimeElementosTab] tab->num_elementos = %d\n", tab->num_elementos);
  if (tab == NULL) {
    return -1;
  }
  else if (tab->num_elementos > 0) {
    i = (tab->num_elementos - 1);
    while (i >= 0)  {
      printf("#DEBUG: [imprimeElementosTab, while] tab->elemento[%d].id = %s\n", i, tab->elemento[i].id);
      i--;
    }
  }
  return 0;
}

// int criaTabela(TabelaSimb *tabela) {
//   TabelaSimb *tab, ttt2;
//   tab = malloc (1 * sizeof(TabelaSimb));
//   if (tab == NULL)
//     return(-1);
// 
//   tab->num_elementos = 0;
// 
//   printf("#DEBUG: [criatabela] tab->num_elementos = %d\n", tab->num_elementos);
//   
//   printf("#DEBUG: [criatabela] sizeof(tab) = %ld\n", sizeof(tab));
//   printf("#DEBUG: [criatabela] sizeof(*tab) = %ld\n", sizeof(*tab));
//   printf("#DEBUG: [criatabela] sizeof(ttt2) = %ld\n", sizeof(ttt2));
//   
//   strcpy(tab->elemento[5].id, "aeee");
//   strcpy(tabela->elemento[5].id, "oba, copiou!");
//   
//   // tab->elemento[5].id = "Aeeee";
//   // sprintf(tab->elemento[5].id, "Aeeee");
//   printf("#DEBUG: [criatabela] tab->elemento[5].id = %s\n", tab->elemento[5].id);
//   
//   // printf("#DEBUG: [criatabela] tab = %d\n", tab);
// 
//   // Elemento el1;
//   // el1 = malloc (1 * sizeof(Elemento));
// 
//   tabela = tab;
//   return 0;
// };

// int inicializaTabela(TabelaSimb *tabela) {
//   if (tab == NULL) {
//     return -1;
//   }
//   else {
//     tab->num_elementos = 0;
//   }
//   return 0;
// }

// int removeElemento(char *id);