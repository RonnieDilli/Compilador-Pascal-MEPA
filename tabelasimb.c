#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"
#include "tabelasimb.h"
#include "pilha.h"
#include "trataerro.h"

SimboloT *procuraSimboloTab(TabelaSimbT *tab, char *id, int nivel_lexico) {
  SimboloT *simbolo;
  simbolo = retornaSimboloTab(tab, id, nivel_lexico);

  if ( simbolo == NULL ) {
    trataErro(ERRO_SINT_IDENT_NAO_ENC, id);
  }
  return simbolo;
}

SimboloT *retornaSimboloTab(TabelaSimbT *tab, char *id, int nivel_lexico) {
  SimboloT *simbolo;
  if (tab == NULL ) {
    trataErro(ERRO_TAB_NAO_ALOC, "");
   }
  else {
    simbolo=tab->ultimo;
    while (simbolo != NULL) {
      if ( (strcmp(simbolo->id, id) == 0)  )// && (simbolo->nivel_lexico <= nivel_lexico))
        break;
      simbolo = simbolo->ant;
    }
    return simbolo;
  }
  return NULL;
}

SimboloT *insereSimboloTab(TabelaSimbT *tab, char *id, CategoriaT categoria, int nivel_lexico) {
  SimboloT *simbolo;
  if (tab == NULL ) {
    trataErro(ERRO_TAB_NAO_ALOC, "");
  }
  else {
    simbolo = retornaSimboloTab(tab, id, nivel_lexico);
    debug_print("[else] id = %s\n", id);
    // if ( simbolo != NULL ) {
    if ( 0 ) {    /* #TODO Detectar se simbolo ja foi declarado pela fun, proc */
      trataErro(WARN_IDENT_JA_DEC, id);
    }
    else {
      simbolo = malloc (sizeof (SimboloT));
      if (simbolo == NULL) {
        trataErro(ERRO_ALOCACAO, "");
      }
      strcpy(simbolo->id, id);
      simbolo->categoria = categoria;
      simbolo->nivel_lexico = nivel_lexico;

      tab->num_simbolos++;
      
      if (categoria == FUN || categoria == PROC)
        simbolo->lista_param = malloc (sizeof (ParametroT) * TAM_LISTA_PARAM);

      if (tab->num_simbolos == 1) {
        tab->primeiro = simbolo;
        simbolo->ant = simbolo->prox = NULL;
      }
      else {
        simbolo->ant  = tab->ultimo;
        simbolo->ant->prox  = simbolo;
        simbolo->prox = NULL;
        simbolo->tipo = T_UNSET;
      }
      tab->ultimo = simbolo;
    }
  }
  return simbolo;
}

int removeSimboloTab(TabelaSimbT *tab, SimboloT *simbolo) {
  if (tab == NULL ) {
    trataErro(ERRO_TAB_NAO_ALOC, "");  }
  else {
    if ( simbolo == NULL ) {
      trataErro(ERRO_SIMB_NAO_ENC, "");
    }
    else {
      if (simbolo == tab->primeiro) {
        tab->primeiro = simbolo->prox;
      }
      else
        simbolo->ant->prox = simbolo->prox;
      if (simbolo == tab->ultimo) {
        // debug_print("[ultimo1]simbolo->id = %s\n", simbolo->id);
        tab->ultimo = simbolo->ant;
      }
      else
        simbolo->prox->ant = simbolo->ant;

      tab->num_simbolos--;
      // debug_print("[rm]simbolo->id = %s\n", simbolo->id);
      free(simbolo);
    }
  }
  return 0;
}

int removeFPSimbolosTab(TabelaSimbT *tab, SimboloT *pai) {
  SimboloT *simbolo;
  int nivel_lexico;
  int num_var_simples;

  if (tab == NULL ) {
    trataErro(ERRO_TAB_NAO_ALOC, "");  }
  else {
    simbolo = pai;
    if ( simbolo == NULL ) {
      trataErro(ERRO_SIMB_NAO_ENC, "");
    }
    else {
      nivel_lexico = simbolo->nivel_lexico;
      num_var_simples = 0;
      while ( (simbolo=simbolo->prox) != NULL) {
        num_var_simples++;
        removeSimboloTab(tab, simbolo);
      }
    }
  }
  return 0;
}

int atribuiTiposTab(TabelaSimbT *tab, TipoT tipo) {
  SimboloT *simbolo;
  int i;
  if (tab == NULL ) {
    trataErro(ERRO_TAB_NAO_ALOC, "");  }
  else {
    i=0;
    simbolo = tab->ultimo;
    while (simbolo->tipo == T_UNSET) {
      if (simbolo->categoria == VS || simbolo->categoria == FUN || simbolo->categoria == PF) {
        simbolo->tipo = tipo;
        debug_print("[for] tipo = %d\n", tipo);
        i++;
      }
      else {
        break;
      }
      simbolo = simbolo->ant;
    }
    return i;
  }
  return -1;
}

int deslocamentosParamsTab(TabelaSimbT *tab, int num_parametros) {
  SimboloT *simbolo;
  int i;
  if (tab == NULL ) {
    trataErro(ERRO_TAB_NAO_ALOC, "");  }
  else {
    simbolo = tab->ultimo;
    for (i = num_parametros; i >= 0; i--) {
      simbolo->deslocamento = i - (4 + num_parametros);
      simbolo = simbolo->ant;
    }
    return i;
  }
  return -1;
}

int atribuiPassagemTab(TabelaSimbT *tab, PassagemT passagem, int num_vars) {
  SimboloT *simbolo;
  int i;
  if (tab == NULL ) {
    trataErro(ERRO_TAB_NAO_ALOC, "");
  }
  else {
    simbolo = tab->ultimo;
    for (i = 0; i < num_vars; i++) {
      simbolo->passagem = passagem;
      debug_print("[for] simbolo->id = %s\n", simbolo->id);
      simbolo = simbolo->ant;
    }
    return i;
  }
  return -1;
}

int insereParamLista(SimboloT  *simb, TipoT tipo, PassagemT passagem, int n_params) {
  int i;
  if (simb == NULL ) {
    trataErro(ERRO_PARAM_NAO_ENC, "");
  }
  else {
    if (simb->num_parametros >= TAM_LISTA_PARAM ) {
      trataErro(ERRO_MAX_PARAM, "");
    }
    else {
      if (simb->lista_param == NULL ) {
        trataErro(ERRO_LISTA_PARAM_NAO_ALOC, "");
      }
      else {
        for (i=0; i < n_params; i++) { // #TODO inverter a ordem?
          debug_print("[for] simb->id = %s, passagem = %d, soma = %d\n", simb->id, passagem, (simb->num_parametros - n_params + i));
          simb->lista_param[simb->num_parametros - n_params + i].tipo = tipo;
          simb->lista_param[simb->num_parametros - n_params + i].passagem = passagem;
          // simb->prox->tipo = tipo;
        }
      }
    }
  }
  return 0;
}

int imprimeTabSimbolos(TabelaSimbT *tab) {
  SimboloT *simbolo;
  int total_simbolos = 0;
  if (tab == NULL ) {
    trataErro(ERRO_TAB_NAO_ALOC, "");
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
