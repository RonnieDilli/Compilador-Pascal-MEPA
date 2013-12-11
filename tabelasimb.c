#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"
#include "tabelasimb.h"
#include "pilha.h"

SimboloT *procuraSimboloTab(TabelaSimbT *tab, char *id, int nivel_lexico) {
  SimboloT *simbolo;
  simbolo = retornaSimboloTab(tab, id, nivel_lexico);

  if ( simbolo == NULL ) {
    fprintf(stderr, "ERRO: *** Erro sintatico!\n => O identificador '%s' nao foi encontrado.\n", id);
    exit(10);
  }
  else {
    return simbolo;
  }
}

SimboloT *retornaSimboloTab(TabelaSimbT *tab, char *id, int nivel_lexico) {
  SimboloT *simbolo;
  if (tab == NULL ) {
    fprintf(stderr, "ERRO: *** Tabela de simbolos dinamica nao foi alocada!\n");
    exit(2);
  }
  else {
    simbolo=tab->ultimo;
    while (simbolo != NULL) {
      debug_print("[while]simbolo->id = %s  -  id = %s\n", simbolo->id, id);
      if ( (strcmp(simbolo->id, id) == 0)  )// && (simbolo->nivel_lexico <= nivel_lexico))
        break;
      simbolo = simbolo->ant;
    }
    debug_print("[end] return %d  -  id = %s\n", simbolo, id);
    return simbolo;
  }
  return NULL;
}

SimboloT *insereSimboloTab(TabelaSimbT *tab, char *id, CategoriaT categoria, int nivel_lexico) {
  SimboloT *simbolo;
  if (tab == NULL ) {
    fprintf(stderr, "ERRO: *** Tabela de simbolos dinamica nao foi alocada!\n");
    exit(2);
  }
  else {
    simbolo = retornaSimboloTab(tab, id, nivel_lexico);
    // if ( simbolo != NULL ) {
    if ( 0 ) {
      fprintf(stderr, "Warning:\n => O identificador '%s' jah foi declarado anteriormente.\n", id);
      // exit(5);
    }
    else {
      simbolo = malloc (sizeof (SimboloT));
      if (simbolo == NULL) {
        fprintf(stderr, "ERRO: *** Nao foi possivel alocar espaco na memoria!\n");
        exit(3);
      }
      strcpy(simbolo->id, id);
      simbolo->categoria = categoria;
      simbolo->nivel_lexico = nivel_lexico;

      tab->num_simbolos++;

      if (tab->num_simbolos == 1) {
        tab->primeiro = simbolo;
        simbolo->ant = simbolo->prox = NULL;
      }
      else {
        simbolo->ant  = tab->ultimo;
        simbolo->ant->prox  = simbolo;
        simbolo->prox = NULL;
      }
      tab->ultimo = simbolo;
    }
  }
  return simbolo;
}

int removeSimboloTab(TabelaSimbT *tab, SimboloT *simbolo) {
  if (tab == NULL ) {
    fprintf(stderr, "ERRO: *** Tabela de simbolos dinamica nao foi alocada!\n");
    exit(2);
  }
  else {
    if ( simbolo == NULL ) {
      fprintf(stderr, "ERRO: *** Impossivel remover!\n => O simbolo nao foi encontrado.\n");
      exit(6);
    }
    else {
      if (simbolo == tab->primeiro) {
        tab->primeiro = simbolo->prox;
      }
      else
        simbolo->ant->prox = simbolo->prox;
      if (simbolo == tab->ultimo) {
        debug_print("[ultimo1]simbolo->id = %s\n", simbolo->id);
        tab->ultimo = simbolo->ant;
      }
      else
        simbolo->prox->ant = simbolo->ant;

      tab->num_simbolos--;
      debug_print("[rm]simbolo->id = %s\n", simbolo->id);
      free(simbolo);
    }
  }
  return 0;
}

int removeSimbolosTab(TabelaSimbT *tab, char *id, int nivel_lexico) {
  SimboloT *simbolo;
  int num_var_simples;
  if (tab == NULL ) {
    fprintf(stderr, "ERRO: *** Tabela de simbolos dinamica nao foi alocada!\n");
    exit(2);
  }
  else {
    simbolo = retornaSimboloTab(tab, id, nivel_lexico);
    if ( simbolo == NULL ) {
      fprintf(stderr, "ERRO: *** Impossivel remover!\n => O identificador '%s' nao foi encontrado.\n", id);
      exit(6);
    }
    else {
      num_var_simples = 0;
      while ( (simbolo=simbolo->prox) != NULL) {
        if (( simbolo->nivel_lexico == nivel_lexico) && ( simbolo->categoria == VS )) {
          num_var_simples++;
          removeSimboloTab(tab, simbolo);
        }
        else
          if (( simbolo->nivel_lexico < nivel_lexico) || ( simbolo->categoria != VS ))
            break;
      }
    }
  }
  return 0;
}

int atribuiTipoSimbTab(TabelaSimbT *tab, char *id, TipoT tipo) {
  SimboloT *simbolo;
  CategoriaT categoria;
  if (tab == NULL) {
    exit(2);
  }
  else {
    simbolo = retornaSimboloTab(tab, id, nivel_lexico);
    if (simbolo != NULL) {
      categoria = simbolo->categoria;
      debug_print("[else-if] categoria = %d\n", categoria);
      if (categoria == FUN || categoria == PF || categoria == VS) {
        simbolo->tipo = tipo;
        debug_print("[else-if-if] simbolo->tipo = %d\n", simbolo->tipo);
        return 0;
      }
    }
    else {
      fprintf(stderr, "ERRO: *** Impossivel atrubuir tipo!\n => O identificador '%s' nao foi encontrado.\n", id);
      exit (7);
    }
  }
  return -1;
}

int atribuiTiposTab(TabelaSimbT *tab, TipoT tipo, int n) {
  SimboloT *simbolo;
  int i;
  if (tab == NULL) {
    exit(2);
  }
  else {
    simbolo = tab->ultimo;
    for (i = 0; i < n; i++) {
      simbolo->tipo = tipo;    /* #TODO Usar funcao atribuiTipoSimbTab (fica mais modular) */
      debug_print("[for] simbolo->tipo = %d\n", simbolo->tipo);
    }
    return i;
  }
  return -1;
}

int imprimeTabSimbolos(TabelaSimbT *tab) {
  SimboloT *simbolo;
  int total_simbolos = 0;
  if (tab == NULL) {
    return -1;
  }
  else {
    printf("[%s] tab->num_simbolos = %d\n", __func__, tab->num_simbolos); // #DEBUG
    simbolo = tab->primeiro;
    while (simbolo != NULL) {
      printf("[%s] simbolo->id= %-5s  tipo(cod)= %d categoria= %d nivel_lexico,deslocamento=(%d,%d)\n", __func__, simbolo->id, simbolo->tipo, simbolo->categoria, simbolo->nivel_lexico, simbolo->deslocamento);
      total_simbolos++;
      simbolo = simbolo->prox;
    }
  }
  printf("[%s] Total de simbolos = %d\n", __func__, total_simbolos); // #DEBUG
  return 0;
}
