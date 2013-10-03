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
    fprintf(stderr, "ERRO: *** Impossivel empilhar, a Pilha nao existe!\n");
    exit(-2);
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
    fprintf(stderr, "ERRO: *** Impossivel desempilhar, a Pilha nao existe!\n");
    exit(-2);
  }
  else {
    if (pilha->topo > 0) {
      pilha->topo--;
      return pilha->elemento[pilha->topo];
    }
    else {
      fprintf(stderr, "ERRO: *** Impossivel desempilhar, a Pilha está vazia!\n");
      exit(-2);
    }
  }
}
