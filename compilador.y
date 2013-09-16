
// Testar se funciona corretamente o empilhamento de parâmetros
// passados por valor ou por referência.


%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"
#include "tabelasimb.h"
#include "pilha.h"

int num_vars, id1, id2;
char buf[255];
TabelaSimbT *tab, tabelaSimbDin;

%}

%token PROGRAM ABRE_PARENTESES FECHA_PARENTESES
%token VIRGULA PONTO_E_VIRGULA DOIS_PONTOS PONTO
%token T_BEGIN T_END VAR IDENT ATRIBUICAO
%token NUMERO SOMA SUBTRACAO MULTIPLICACAO DIVISAO
%token OR AND MAIOR_QUE MENOR_QUE
%token IF THEN ELSE WHILE DO GOTO

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

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
                /* #TODO volta setando o tipo das num_vars variaveis na Tabela tab */
              }
              PONTO_E_VIRGULA
;

tipo        : IDENT
;

lista_id_var: lista_id_var VIRGULA IDENT
              { num_vars=num_vars + 1; insereElementosTab(tab, 1); /* insere última vars na tabela de símbolos */ }
            | IDENT { num_vars=num_vars + 1; insereElementosTab(tab, 1); /* insere vars na tabela de símbolos */}
;

lista_idents: lista_idents VIRGULA IDENT
            | IDENT
;


comando_composto: T_BEGIN comandos T_END
;

comandos    : comandos PONTO_E_VIRGULA comando
            | comando
;

comando     : NUMERO DOIS_PONTOS com_sem_rot
            | comando_composto
            | com_sem_rot
            |
;

com_sem_rot : atrib                               { /* TODO: Acabar de escrever a regra */ }
            | com_condic
            | com_repetit
;

atrib       : IDENT ATRIBUICAO expressao          { /* TODO: Confirmar regra */ }
;

com_condic  : IF expressao THEN comando %prec LOWER_THAN_ELSE
            | IF expressao THEN comando ELSE comando
;

com_repetit : WHILE expressao DO comando
;

expressao   : expr_simples relacao expr_simples   { /* TODO: Acabar de escrever a regra */ }
            | expr_simples
;

expr_simples: expr_simples SOMA termo
            | expr_simples SUBTRACAO termo
            | expr_simples OR termo
            | termo
;

termo       : fator MULTIPLICACAO fator
            | fator DIVISAO fator
            | fator AND fator
            | fator
;

fator       : ABRE_PARENTESES expressao FECHA_PARENTESES
            | IDENT
            | NUMERO
;

relacao     : MAIOR_QUE                           { /* TODO: Acabar de escrever a regra */ }
            | MENOR_QUE
;


%%

main (int argc, char** argv) {
   FILE* fp;
   extern FILE* yyin;

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

    tab = &tabelaSimbDin;
    tab->num_elementos = 0;

    strcpy(tab->elemento[4].id, "Oi passei pelo [main]!"); // #DEBUG
    strcpy(tab->elemento[2].id, "Achei voce! [main]"); // #DEBUG
    debug_print("[%s] tab->num_elementos = %d\n", __func__, tab->num_elementos);

/*    insereElementosTab(tab, 10);*/

/* -------------------------------------------------------------------
 *  Inicializa as variaveis de controle
 * ------------------------------------------------------------------- */


/* -------------------------------------------------------------------
 *  Inicia a Tabela de Símbolos
 * ------------------------------------------------------------------- */

   yyin=fp;
   yyparse();
   
   imprimeElementosTab(tab, "oi"); // DEBUG

   id1 = procuraElementoTab(tab, "Achei voce! #SQN [main]"); // DEBUG

   return 0;
}

