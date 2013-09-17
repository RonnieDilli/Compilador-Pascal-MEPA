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
    debug_print("[%s] pilha == NULL\n", __func__);
    return -1;  // TODO tratar erro
  }
  else if (pilha->topo > PILHA_TAM) {
    fprintf(stderr, "ERRO: *** Tamanho da pilha (%d elementos) excedido!\n", PILHA_TAM);
    exit (-1);
  }
  else {
    pilha->elemento[pilha->topo] = novo_elemento;
    pilha->topo++;
    return 0;
  }
}

void * desempilha(PilhaT *pilha) {
  if (pilha == NULL) {
    debug_print("[%s] pilha == NULL\n", __func__);
    return NULL;  // TODO tratar erro
  }
  else {
    if (pilha->topo > 0) {
      pilha->topo--;
      return pilha->elemento[pilha->topo];
    }
    else {
      debug_print("[%s] pilha->topo <= 0\n", __func__);
      return NULL;  // TODO tratar erro
    }
  }
}
