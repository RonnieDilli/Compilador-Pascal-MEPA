#include <stdio.h>
#include <stdlib.h>
#include "compilador.h"
#include "pilha.h"

int inicializaPilha(PilhaT *pilha) {
  if (pilha == NULL) {
    return -1;
  }
  else {
    pilha->num_elementos = 0;
    return 0;
  }
}

int empilha(PilhaT *pilha, void *novo_elemento) {
  if (pilha == NULL) {
    debug_print("[%s] pilha == NULL\n", __func__);
    return -1;  // TODO tratar erro
  }
  else if (pilha->num_elementos > PILHA_TAM) {
    fprintf(stderr, "ERRO: *** Tamanho da pilha (%d elementos) excedido!\n", PILHA_TAM);
    exit (-1);
  }
  else {
    pilha->elemento[pilha->num_elementos] = novo_elemento;
    pilha->num_elementos++;
    return 0;
  }
}

void * desempilha(PilhaT *pilha) {
  if (pilha == NULL) {
    debug_print("[%s] pilha == NULL\n", __func__);
    return NULL;  // TODO tratar erro
  }
  else {
    if (pilha->num_elementos > 0) {
      pilha->num_elementos--;
      return pilha->elemento[pilha->num_elementos];
    }
    else {
      debug_print("[%s] pilha->num_elementos <= 0\n", __func__);
      return NULL;  // TODO tratar erro
    }
  }
}
