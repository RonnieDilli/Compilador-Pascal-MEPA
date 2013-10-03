
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
#include "aux.h"

int num_vars, ident_1, ident_2, num, *temp_num, nivellexico, cont_rotulo;
char *rot;
TabelaSimbT *tab, tabelaSimbDin;
PilhaT pilha_s, pilha_e, pilha_t, pilha_f, pilha_rot;

%}

%token PROGRAM ABRE_PARENTESES FECHA_PARENTESES
%token VIRGULA PONTO_E_VIRGULA DOIS_PONTOS PONTO
%token T_BEGIN T_END VAR IDENT ATRIBUICAO
%token NUMERO SOMA SUBTRACAO MULTIPLICACAO DIVISAO
%token OR AND MAIOR_QUE MENOR_QUE
%token IF THEN ELSE WHILE DO GOTO
%token PROCEDURE FUNCTION INTEGER BOOLEAN

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

programa    : { geraCodigo (NULL, "INPP"); nivellexico = 0; }
              PROGRAM IDENT ABRE_PARENTESES lista_idents FECHA_PARENTESES PONTO_E_VIRGULA bloco PONTO
              { geraCodigo (NULL, "PARA"); }
;

bloco       : parte_declara_vars
              { geraCodigoArgs (NULL, "DSVS %s", "R00"); geraRotulo(&rot, &cont_rotulo);
                geraCodigo (rot, "NADA"); empilha(&pilha_rot, rot); }
              comando_composto
;

parte_declara_vars:  var
;

var         : VAR declara_vars
            |
;

declara_vars: declara_vars declara_var
            | declara_var
;

declara_var : { num_vars=0; }
              lista_id_var DOIS_PONTOS tipo { geraCodigoArgs (NULL, "AMEM %d", num_vars); }
              PONTO_E_VIRGULA
;

tipo        : INTEGER { atribuiTiposTab(tab, T_INTEGER, num_vars); }
            | BOOLEAN { atribuiTiposTab(tab, T_BOOLEAN, num_vars); }
            | IDENT   { atribuiTiposTab(tab, T_UNKNOWN, num_vars); } /* Tipo Desconhecido(ou nao tratado). #TODO Adicionar Tipos Basicos: integer, boolean, char, real  (and maybe string)  */
;

lista_id_var: lista_id_var VIRGULA IDENT  { num_vars=num_vars + 1; insereElementosTab(tab, token); } /* insere última vars na tabela de símbolos */
            | IDENT                       { num_vars=num_vars + 1; insereElementosTab(tab, token); } /* insere vars na tabela de símbolos */
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

com_sem_rot : atrib       /* #TODO Acabar de escrever a regra */
            | com_condic
            | com_repetit
;

atrib       : IDENT                 { ident_1 = procuraElementoTab(tab, token); }
              ATRIBUICAO expressao  { geraCodigoArgs (NULL, "ARMZ %d,%d", nivellexico, ident_1); }  /* #TODO Confirmar regra */
;

com_condic  : IF expressao THEN comando %prec LOWER_THAN_ELSE
            | IF expressao THEN comando ELSE comando
;

com_repetit : WHILE { geraRotulo(&rot, &cont_rotulo);
                      geraCodigo (rot, "NADA");
                      empilha(&pilha_rot, rot); }
              expressao DO comando
                    { geraRotulo(&rot, &cont_rotulo);
                      geraCodigo (rot, "NADA");
                      empilha(&pilha_rot, rot); }
;

expressao   : expr_simples relacao          /* #TODO Acabar de escrever a regra */
            | expr_simples
;

expr_simples: expr_simples SOMA termo       { geraCodigo (NULL, "SOMA"); }
            | expr_simples SUBTRACAO termo  { geraCodigo (NULL, "SUBT"); }
            | expr_simples OR termo         { geraCodigo (NULL, "DISJ"); }
            | termo
;

termo       : fator MULTIPLICACAO fator { geraCodigo (NULL, "MULT"); }
            | fator DIVISAO fator       { geraCodigo (NULL, "DIVI"); }
            | fator AND fator           { geraCodigo (NULL, "CONJ"); }
            | fator
;

fator       : ABRE_PARENTESES expressao FECHA_PARENTESES
            | IDENT   { ident_2 = procuraElementoTab(tab, token);
                        geraCodigoArgs (NULL, "CRVL %d,%d", nivellexico, ident_2); }
            | NUMERO  { geraCodigoArgs (NULL, "CRCT %d", atoi(token)); }
                        // temp_num = malloc (sizeof (int));
                        // *temp_num = atoi(token);
                        // empilha(&pilha_s, temp_num); /* CRCT x */
                        // debug_print(".linha=%d: *temp_num = %d\n", nl, *temp_num );
                        // geraCodigoArgs (NULL, "CRCT %d", *temp_num);

                        // temp_num = malloc (sizeof (int));
                        // *temp_num = 44;
                        // empilha(&pilha_s, temp_num); /* CRCT x */
                        // temp_num = malloc (sizeof (int));
                        // *temp_num = 66;
                        // empilha(&pilha_s, temp_num); /* CRCT x */
                        // num = *(int *)(desempilha(&pilha_s));
                        // debug_print(".linha=%d: num = %d\n", nl, num );
                        // num = *(int *)(desempilha(&pilha_s));
                        // debug_print(".linha=%d: num = %d\n", nl, num );
                        // num = *(int *)(desempilha(&pilha_s));
                        // debug_print(".linha=%d: num = %d\n", nl, num );
;

relacao     : MAIOR_QUE expr_simples  { geraCodigo (NULL, "CMMA"); }    /* #TODO Acabar de escrever a regra */
            | MENOR_QUE expr_simples  { geraCodigo (NULL, "CMME"); }
;

%%

int main (int argc, char** argv) {
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
    cont_rotulo = 0;

    // debug_print("tab->num_elementos = %d\n", tab->num_elementos);

    // insereElementosTab(tab, 10); // #DEBUG - Teste

/* -------------------------------------------------------------------
 *  Inicializa as variaveis de controle
 * ------------------------------------------------------------------- */

/* -------------------------------------------------------------------
 *  Inicia a Tabela de Símbolos
 * ------------------------------------------------------------------- */

   yyin=fp;
   yyparse();

   imprimeElementosTab(tab); // #DEBUG

   return 0;
}
