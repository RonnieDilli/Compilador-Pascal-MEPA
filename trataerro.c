#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "trataerro.h"
#include "compilador.h"
#include "tabelasimb.h"
#include "pilha.h"

int trataErro(ErroT cod_erro, char *str) {
  switch (cod_erro) {
  case SEM_ERRO:
    break;

    /* Erros Sintaticos */
  case ERRO_SINT_IDENT_NAO_ENC:
    fprintf(stderr, "ERRO: *** Erro sintatico!\n => O identificador '%s' nao foi encontrado.\n", str);
    exit(cod_erro);

  case ERRO_IDENT_JA_DEC:
    fprintf(stderr, "Warning:\n => O identificador '%s' jah foi declarado anteriormente.\n", str);
    exit(cod_erro);

  case ERRO_TAB_NAO_ALOC:
    fprintf(stderr, "ERRO: *** Tabela de simbolos dinamica nao foi alocada!\n");
    exit(cod_erro);
  case ERRO_SIMB_NAO_ENC:
    fprintf(stderr, "ERRO: *** Impossivel remover!\n => O simbolo %s nao foi encontrado.\n", str);
    exit(cod_erro);

    /* Lista de Parametros */
  case ERRO_LISTA_PARAM_NAO_ALOC:
    fprintf(stderr, "ERRO: *** A Lista Parametros nao foi alocada!\n");
    exit(cod_erro);
  case ERRO_PARAM_NAO_ENC:
    fprintf(stderr, "ERRO: *** O Parametro nao foi encontrado, impossivel inserir na Lista de Parametros!\n");
    exit(cod_erro);
  case ERRO_MAX_PARAM:
    fprintf(stderr, "ERRO: ***\n => O numero de Parametros (%d) passou do limite interno.\n", TAM_LISTA_PARAM);
    exit(cod_erro);

    /* PILHA */
  case ERRO_PILHA_N_EXISTE:
    fprintf(stderr, "ERRO: *** Impossivel desempilhar, a Pilha nao existe!\n");
    exit(cod_erro);
  case ERRO_PILHA_VAZIA:
    fprintf(stderr, "ERRO: *** Impossivel desempilhar, a Pilha está vazia!\n");
    exit(cod_erro);
  case ERRO_PILHA_TAM_EXCED:
    fprintf(stderr, "ERRO: *** Tamanho da pilha (%d elementos) excedido!\n", PILHA_TAM);
    exit(cod_erro);

  case ERRO_ALOCACAO:
    fprintf(stderr, "ERRO: *** Nao foi possivel alocar espaco na memoria!\n");
    exit(cod_erro);

    /* WARNING */  
  case WARN_IDENT_JA_DEC:
    fprintf(stderr, "Warning:\n => O identificador '%s' jah foi declarado anteriormente.\n", str);
    break;

  default:
    fprintf(stderr, "ERRO: *** Erro desconhecido!\n");
    exit(cod_erro);
  }
  return 0;
}