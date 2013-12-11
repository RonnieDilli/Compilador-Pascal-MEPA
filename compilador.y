
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

int num_vars, nivel_lexico, deslocamento, cont_rotulo, *temp_num; /* #DEBUG vars: num, *temp_num, i */
char *rotulo_mepa, *rotulo_mepa_aux;
SimboloT *simb, *simb_aux;

TabelaSimbT *tab, tabelaSimbDin;
PilhaT pilha_rot, pilha_tipos, pilha_amem_dmem;

TipoT tipo_aux;

/* Empilha numero de vars locais para posterior DMEM */
#define empilhaAMEM(n_vars) \
  temp_num = malloc (sizeof (int)); \
    *temp_num = n_vars; \
      empilha(&pilha_amem_dmem, temp_num);
#define geraCodigoDMEM() \
  num_vars = *(int *)desempilha(&pilha_amem_dmem); \
    if (num_vars) {geraCodigoArgs (NULL, "DMEM %d", num_vars); }
#define geraCodigoLEIT() \
  geraCodigo (NULL, "LEIT"); simb = procuraSimboloTab(tab, token, nivel_lexico); \
    geraCodigoArgs (NULL, "ARMZ %d, %d", simb->nivel_lexico, simb->deslocamento);
#define geraCodigoIMPR() \
  simb = procuraSimboloTab(tab, token, nivel_lexico); \
    geraCodigoArgs (NULL, "CRVL %d, %d", simb->nivel_lexico, simb->deslocamento); \
      geraCodigo (NULL, "IMPR");
#define geraCodigoENPR(categoria) \
  geraRotulo(&rotulo_mepa, &cont_rotulo, &pilha_rot); \
    geraCodigoArgs (desempilha(&pilha_rot), "ENPR %d", ++nivel_lexico); deslocamento = 0; \
      simb = insereSimboloTab(tab, token, categoria, nivel_lexico); \
        simb->rotulo = rotulo_mepa;

%}

%token PROGRAM ABRE_PARENTESES FECHA_PARENTESES
%token VIRGULA PONTO_E_VIRGULA DOIS_PONTOS PONTO
%token T_BEGIN T_END VAR IDENT ATRIBUICAO
%token NUMERO SOMA SUBTRACAO MULTIPLICACAO DIVISAO
%token OR AND MAIOR_QUE MENOR_QUE MAIOR_OU_IGUAL MENOR_OU_IGUAL IGUAL
%token IF THEN ELSE WHILE DO GOTO READ WRITE
%token PROCEDURE FUNCTION INTEGER BOOLEAN

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

programa    : { geraCodigo (NULL, "INPP"); nivel_lexico = deslocamento = 0; }
              PROGRAM IDENT ABRE_PARENTESES lista_idents FECHA_PARENTESES PONTO_E_VIRGULA bloco PONTO
              { geraCodigoDMEM(); geraCodigo (NULL, "PARA"); }
;

bloco       : parte_declara_vars  { empilhaAMEM(deslocamento);
                                    geraRotulo(&rotulo_mepa, &cont_rotulo, &pilha_rot);
                                    geraCodigoArgs (NULL, "DSVS %s", rotulo_mepa); }
              procs_funcs         { geraCodigo (desempilha(&pilha_rot), "NADA"); }
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
            | IDENT   { atribuiTiposTab(tab, T_UNKNOWN, num_vars); } /* Tipo Desconhecido(ou nao tratado). #Sugestao: Adicionar Tipos Basicos: integer, boolean, char, real  (and maybe string)  */
;

lista_id_var: lista_id_var VIRGULA IDENT  { num_vars++; simb = insereSimboloTab(tab, token, VS, nivel_lexico); simb->deslocamento = deslocamento++; } /* insere ultima var na tabela de simbolos */
            | IDENT                       { num_vars++; simb = insereSimboloTab(tab, token, VS, nivel_lexico); simb->deslocamento = deslocamento++; } /* insere vars na tabela de simbolos */
;

lista_idents: lista_idents VIRGULA IDENT
            | IDENT
;

procs_funcs : PROCEDURE IDENT   { geraCodigoENPR(PROC); }
              vars_proc_func PONTO_E_VIRGULA bloco_proc_func
            | FUNCTION IDENT    { geraCodigoENPR(FUN); }
              vars_proc_func    { simb->end_retorno = -4 - simb->num_parametros; } /* #TODO Tratar parametros e seus tipos, num_parametros, etc */
              DOIS_PONTOS       { num_vars=1; }  /*  ^  #FIXME (simb->end_retorno) Procurar a posicao adequada (usar pilha??) */
              tipo PONTO_E_VIRGULA bloco_proc_func
            | 
;

bloco_proc_func: parte_declara_vars         { empilhaAMEM(deslocamento); }
              procs_funcs comando_composto
              PONTO_E_VIRGULA               { geraCodigoDMEM();
                                              simb = tab->primeiro; /* #FIXME Procurar a posicao adequada */
                                              geraCodigoArgs (NULL, "RTPR %d, %d", nivel_lexico--, simb->num_parametros); }
              procs_funcs
;

vars_proc_func: ABRE_PARENTESES parte_declara_vars FECHA_PARENTESES /* #TODO Tratar declaracao de parametros, ref e valor */
            |
;

comando_composto: T_BEGIN comandos T_END
;

comandos    : comandos PONTO_E_VIRGULA comando
            | comando
;

comando     : NUMERO DOIS_PONTOS com_sem_rot  /* #TODO Tratar rotulo_pascal aqui */
            | comando_composto
            | com_sem_rot
            |
;

com_sem_rot : atrib
            | com_condic
            | com_repetit
            | READ ABRE_PARENTESES lista_param_leit FECHA_PARENTESES
            | WRITE ABRE_PARENTESES lista_param_impr FECHA_PARENTESES   /* #TODO Acabar de escrever a regra, adicionar 'procedures': p; p(); p(var1, var2); */
;

lista_param_leit: lista_param_leit VIRGULA IDENT  { geraCodigoLEIT(); }
            | IDENT                               { geraCodigoLEIT(); } /* #TODO Verificar se 'simb' eh de tipo compativel com atribuicao e passado por referencia */
;

lista_param_impr: lista_param_impr VIRGULA IDENT  { geraCodigoIMPR(); }
            | IDENT                               { geraCodigoIMPR(); }  /* #TODO Verificar se 'simb' eh de tipo compativel com atribuicao e passado por referencia */
;

atrib       : IDENT                 { simb_aux = procuraSimboloTab(tab, token, nivel_lexico); empilhaTipoT(&pilha_tipos, simb_aux->tipo); }
              ATRIBUICAO expressao  { geraCodigoArgs (NULL, "ARMZ %d, %d", simb_aux->nivel_lexico, simb_aux->deslocamento); }  /* #TODO Arrumar codigo: comparar tipos ao final. (pilha de identificadores?) suportar 'fn = 4;' */
;

com_condic  : if_simples %prec LOWER_THAN_ELSE  { geraCodigo (desempilha(&pilha_rot), "NADA"); }
            | if_simples ELSE { rotulo_mepa_aux=desempilha(&pilha_rot);
                                geraRotulo(&rotulo_mepa, &cont_rotulo, &pilha_rot);
                                geraCodigoArgs (NULL, "DSVS %s", rotulo_mepa);
                                geraCodigo (rotulo_mepa_aux, "NADA"); }
              comando         { geraCodigo (desempilha(&pilha_rot), "NADA"); }
;

if_simples  : IF            { geraRotulo(&rotulo_mepa, &cont_rotulo, &pilha_rot); }
              expressao     { geraCodigoArgs (NULL, "DSVF %s", rotulo_mepa); }
              THEN comando
;

com_repetit : WHILE       { geraRotulo(&rotulo_mepa, &cont_rotulo, &pilha_rot);
                            geraCodigo (rotulo_mepa, "NADA"); }
              expressao   { geraRotulo(&rotulo_mepa, &cont_rotulo, &pilha_rot);
                            geraCodigoArgs (NULL, "DSVF %s", rotulo_mepa); }
              DO comando  { rotulo_mepa_aux=desempilha(&pilha_rot);
                            rotulo_mepa=desempilha(&pilha_rot);
                            geraCodigoArgs (NULL, "DSVS %s", rotulo_mepa);
                            geraCodigo (rotulo_mepa_aux, "NADA"); }
;

expressao   : expr_simples relacao          /* #TODO Conferir regra */
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
            | IDENT   { simb = procuraSimboloTab(tab, token, nivel_lexico);
                        geraCodigoArgs (NULL, "CRVL %d, %d", simb->nivel_lexico, simb->deslocamento);
                        empilhaTipoT(&pilha_tipos, simb->tipo); }
            | NUMERO  { geraCodigoArgs (NULL, "CRCT %d", atoi(token));
                        empilhaTipoT(&pilha_tipos, T_INTEGER); }

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

relacao     : MAIOR_QUE expr_simples  { geraCodigo (NULL, "CMMA"); }    /* #TODO Conferir regra (e verificar tipos) */
            | MENOR_QUE expr_simples  { geraCodigo (NULL, "CMME"); }
            | MAIOR_OU_IGUAL expr_simples  { geraCodigo (NULL, "CMAG"); }
            | MENOR_OU_IGUAL expr_simples  { geraCodigo (NULL, "CMEG"); }
            | IGUAL expr_simples  { geraCodigo (NULL, "CMIG"); }
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
  tab->num_simbolos = 0;
  tab->primeiro=tab->ultimo=NULL;
  inicializaPilha(&pilha_rot);
  inicializaPilha(&pilha_tipos);

/* -------------------------------------------------------------------
 *  Inicializa as variaveis de controle
 * ------------------------------------------------------------------- */

  cont_rotulo = 0;

/* -------------------------------------------------------------------
 *  Inicia a Tabela de Símbolos
 * ------------------------------------------------------------------- */

  yyin=fp;
  yyparse();

#ifdef DEBUG
  // int i;
  // for (i=0; i<25; i++) {
  //   tipo_aux = *(TipoT *)(desempilha(&pilha_tipos));
  //   debug_print("[TipoT Tests] i=[%d].tipo_aux = %d\n", i, tipo_aux);
  // }

//  imprimeTabSimbolos(tab); // #DEBUG
//  atribuiTipoSimbTab(tab, "f1", T_REAL);   // #DEBUG
  imprimeTabSimbolos(tab); // #DEBUG

  removeSimbolosTab(tab, "f1", 1);

  imprimeTabSimbolos(tab); // #DEBUG
#endif

  return 0;
}
