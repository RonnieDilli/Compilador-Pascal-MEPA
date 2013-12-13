#include <stdio.h>
#include <stdlib.h>
#include "compilador.h"
#include "tabelasimb.h"
#include "pilha.h"
#include "trataerro.h"
#include "aux.h"

int geraRotulo(char **novo_rotulo, int *contador, PilhaT *pilha_rot) {
  char *rot;

  *novo_rotulo = malloc (sizeof (char [ROTULO_TAM]));
  if (*novo_rotulo == NULL) {
    trataErro(ERRO_ALOCACAO, "");
  }
  sprintf(*novo_rotulo, "R%02d", *contador);
  *contador = *contador + 1;
  
  empilha(pilha_rot, *novo_rotulo);

  return 0;
}

int empilhaTipoT(PilhaT *pilha, TipoT novo_tipo) {
  TipoT *tipo_aux;

  tipo_aux = malloc (sizeof (TipoT));
  if (tipo_aux == NULL) {
    trataErro(ERRO_ALOCACAO, "");
  }
  *tipo_aux = novo_tipo;
  empilha(pilha, tipo_aux);

  return 0;
}

int confereTipo(PilhaT *pilha, OperacaoT op, TipoT tipo_esperado) {
  TipoT tipo_esquerda, tipo_direita;
  
  int i;
  if (pilha == NULL ) {
    trataErro(ERRO_PILHA_N_EXISTE, "");
  }
  else {
    tipo_direita= *(TipoT *)desempilha(pilha);
    tipo_esquerda= *(TipoT *)desempilha(pilha);
    switch (op) {
      case OP_CALCULO:
        empilhaTipoT(pilha, tipo_direita);
        break;
      case OP_COMPARACAO:
        empilhaTipoT(pilha, T_BOOLEAN);
        break;
      case OP_ATRIBUICAO:
        empilhaTipoT(pilha, tipo_esquerda);
        break;
      }
      debug_print("[TipoT Tests] tipo_esquerda= %d - tipo_direita= %d\n", tipo_esquerda, tipo_direita);
    if (tipo_esquerda == tipo_direita)
      return 1;
    else
      trataErro(ERRO_TIPO, "");
      return 0;
  } 
  return 0;
}
