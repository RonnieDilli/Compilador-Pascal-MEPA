#include <stdio.h>
#include <stdlib.h>
#include "compilador.h"
#include "pilha.h"

int inicializaPilha(PilhaT *pilha) {
  if (pilha == NULL) {
    return -1;
  }
  else {
    pilha->topo = 0;
    return 0;
  }
}

int empilha(PilhaT *pilha, void *novo_elemento) {
  if (pilha == NULL) {
    debug_print("pilha == %s\n", "NULL");
    exit(-2);
    // return -1;  // TODO tratar erro
  }
  else if (pilha->topo > PILHA_TAM) {
    fprintf(stderr, "ERRO: *** Tamanho da pilha (%d elementos) excedido!\n", PILHA_TAM);
    exit (-1);
  }
  else {
    debug_print("+%d\n", 1);
    pilha->elemento[pilha->topo] = novo_elemento;
    pilha->topo++;
    return 0;
  }
}

void * desempilha(PilhaT *pilha) {
  if (pilha == NULL) {
    debug_print("pilha == %s\n", "NULL");
    return NULL;  // TODO tratar erro
  }
  else {
    if (pilha->topo > 0) {
      pilha->topo--;
      return pilha->elemento[pilha->topo];
    }
    else {
      debug_print("pilha->topo = %d\n", pilha->topo);
      exit(-2);
      // return NULL;  // TODO tratar erro
    }
  }
}
