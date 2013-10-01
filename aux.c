#include <stdio.h>
#include <stdlib.h>
#include "compilador.h"
#include "pilha.h"
#include "aux.h"

int geraRotulo(char **novo_rotulo, int *contador) {
  char *rot;

  *novo_rotulo = malloc (sizeof (char [ROTULO_TAM]));
  sprintf(*novo_rotulo, "R%02d", *contador);
  *contador = *contador + 1;
  return 0;
}

