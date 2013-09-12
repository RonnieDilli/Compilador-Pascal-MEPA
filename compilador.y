
// Testar se funciona corretamente o empilhamento de parâmetros
// passados por valor ou por referência.


%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"
#include "tabelasimb.h"

int num_vars;
char buf[255];

%}

%token PROGRAM ABRE_PARENTESES FECHA_PARENTESES 
%token VIRGULA PONTO_E_VIRGULA DOIS_PONTOS PONTO
%token T_BEGIN T_END VAR IDENT ATRIBUICAO
%token NUMERO SOMA SUBTRACAO MULTIPLICACAO DIVISAO
%token OR AND MAIOR_QUE MENOR_QUE
%token IF THEN WHILE DO GOTO

%%

programa    :{ 
             geraCodigo (NULL, "INPP"); 
             }
             PROGRAM IDENT 
             ABRE_PARENTESES lista_idents FECHA_PARENTESES PONTO_E_VIRGULA
             bloco PONTO {
             geraCodigo (NULL, "PARA"); 
             }
;

bloco       : 
              parte_declara_vars
              { 
              }

              comando_composto 
              ;




parte_declara_vars:  var 
;


var         : { } VAR declara_vars
            |
;

declara_vars: declara_vars declara_var 
            | declara_var 
;

declara_var : { num_vars=0; } 
              lista_id_var DOIS_PONTOS 
              tipo 
              {
                sprintf(buf, "AMEN %d", num_vars);
                geraCodigo (NULL, buf);  /* AMEM */
              }
              PONTO_E_VIRGULA
;

tipo        : IDENT
;

lista_id_var: lista_id_var VIRGULA IDENT 
              { num_vars=num_vars + 1; /* insere última vars na tabela de símbolos */ }
            | IDENT { num_vars=num_vars + 1; /* insere vars na tabela de símbolos */}
;

lista_idents: lista_idents VIRGULA IDENT 
            | IDENT
;


comando_composto: T_BEGIN comandos T_END 
;

comandos:     comandos PONTO_E_VIRGULA comando
              | comando
;

comando:      NUMERO DOIS_PONTOS com_sem_rot
              | com_sem_rot
;

com_sem_rot:  atrib                               { /* TODO: Acabar de escrever a regra */ }
;

atrib:        IDENT ATRIBUICAO expr_simples PONTO_E_VIRGULA          { /* TODO: Acabar de escrever a regra */ }
;

expr_simples:    expressao | expressao operando expressao   { /* TODO: Acabar de escrever a regra */ }
;

expressao:    expressao SOMA T               { /* TODO: Acabar de escrever a regra */ }
              | expressao OR T
              | T
;

T:            NUMERO            { /* TODO: Acabar de escrever a regra */ }
;

operando:     '+' | '-'       { /* TODO: Acabar de escrever a regra */ }
;

%%

main (int argc, char** argv) {
   FILE* fp;
   extern FILE* yyin;
   
   TabelaSimb *tabelaSimbDin;

   if (argc<2 || argc>2) {
         printf("usage compilador <arq>a %d\n", argc);
         return(-1);
      }

   fp=fopen (argv[1], "r");
   if (fp == NULL) {
      printf("usage compilador <arq>b\n");
      return(-1);
   }

/* -------------------------------------------------------------------
 *  Inicia a Tabela de Símbolos Dinamica (pilha)
 * ------------------------------------------------------------------- */

   if (!criaTabela(tabelaSimbDin)) {
     printf("#DEBUG: Tabela de simbolos Dinamica criada!\n\n");
   }
/* -------------------------------------------------------------------
 *  Inicializa as variaveis de controle
 * ------------------------------------------------------------------- */


/* -------------------------------------------------------------------
 *  Inicia a Tabela de Símbolos
 * ------------------------------------------------------------------- */

   yyin=fp;
   yyparse(); 

   return 0;
}

