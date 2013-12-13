#include <stdio.h>
#include <stdlib.h>
#include "compilador.h"
#include "trataerro.h"
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
    trataErro(ERRO_PILHA_N_EXISTE, "");
  }
  else if (pilha->topo > PILHA_TAM) {
    trataErro(ERRO_PILHA_TAM_EXCED, "");
  }
  else {
    pilha->elemento[pilha->topo] = novo_elemento;
    pilha->topo++;
  }
  return 0;
}

void * desempilha(PilhaT *pilha) {
  if (pilha == NULL) {
    trataErro(ERRO_PILHA_N_EXISTE, "");
  }
  else if (pilha->topo > 0) {
    pilha->topo--;
    return pilha->elemento[pilha->topo];
  }
  else {
    trataErro(ERRO_PILHA_VAZIA, "");
  }
  return NULL;
}
void * desempilhaMesmoNULL(PilhaT *pilha) {
  if (pilha == NULL) {
    trataErro(ERRO_PILHA_N_EXISTE, "");
  }
  else if (pilha->topo > 0) {
    pilha->topo--;
    return pilha->elemento[pilha->topo];
  }
  return NULL;
}
