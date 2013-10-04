#include <stdio.h>
#include <stdlib.h>
#include "compilador.h"
#include "tabelasimb.h"
#include "pilha.h"
#include "aux.h"

int geraRotulo(char **novo_rotulo, int *contador, PilhaT *pilha_rot) {
  char *rot;

  *novo_rotulo = malloc (sizeof (char [ROTULO_TAM]));
  sprintf(*novo_rotulo, "R%02d", *contador);
  *contador = *contador + 1;
  
  empilha(pilha_rot, *novo_rotulo);

  return 0;
}

int confereTipo(OperacaoT op, TipoT tipo_esperado, TipoT tipo_obtido);