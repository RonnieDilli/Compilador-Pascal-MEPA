
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
#include "trataerro.h"

int num_vars, nivel_lexico, deslocamento, cont_rotulo, *temp_num, indice_param;
char *rotulo_mepa, *rotulo_mepa_aux;
SimboloT *simb, *simb_aux;

TabelaSimbT *tab, tabelaSimbDin;
PilhaT pilha_rot, pilha_tipos, pilha_amem_dmem, pilha_simbs;

PassagemT passagem;
TipoT tipo_aux;

/* Empilha numero de vars locais para posterior DMEM */
#define empilhaAMEM(n_vars) \
  temp_num = malloc (sizeof (int)); \
    *temp_num = n_vars; \
      empilha(&pilha_amem_dmem, temp_num);
#define geraCodigoDMEM() \
  num_vars = *(int *)desempilha(&pilha_amem_dmem); \
    if (num_vars) {geraCodigoArgs (NULL, "DMEM %d", num_vars); }

#define geraCodigoARMZI(simbolo) \
  if (simbolo->passagem == T_VALOR) { geraCodigoArgs (NULL, "ARMZ %d, %d", simbolo->nivel_lexico, simbolo->deslocamento); } \
    else { geraCodigoArgs (NULL, "ARMI %d, %d", simbolo->nivel_lexico, simbolo->deslocamento); }
#define geraCodigoCRVLI(simbolo) \
  debug_print("[geraCodigoCRVLI] simbolo->id = '%s', indice_param=%d, passagem=%d\n", simbolo->id, indice_param, passagem); \
  if (passagem == T_REFERENCIA) { if (simbolo->lista_param[indice_param].passagem == T_REFERENCIA) { geraCodigoArgs (NULL, "CREN %d, %d", simbolo->nivel_lexico, simbolo->deslocamento); } \
    else { geraCodigoArgs (NULL, "CRVL %d, %d", simbolo->nivel_lexico, simbolo->deslocamento); } \
      } else if (simbolo->passagem == T_VALOR) { geraCodigoArgs (NULL, "CRVL %d, %d", simbolo->nivel_lexico, simbolo->deslocamento); } \
          else { geraCodigoArgs (NULL, "CRVI %d, %d", simbolo->nivel_lexico, simbolo->deslocamento); }

#define geraCodigoLEIT() \
  geraCodigo (NULL, "LEIT"); simb = procuraSimboloTab(tab, token, nivel_lexico); \
    geraCodigoARMZI(simb);
#define geraCodigoIMPR() \
  simb = procuraSimboloTab(tab, token, nivel_lexico); \
    geraCodigoCRVLI(simb); \
        geraCodigo (NULL, "IMPR");
#define geraCodigoENPR(categoria) \
  geraRotulo(&rotulo_mepa, &cont_rotulo, &pilha_rot); \
    geraCodigoArgs (desempilha(&pilha_rot), "ENPR %d", ++nivel_lexico); \
      simb = insereSimboloTab(tab, token, categoria, nivel_lexico); \
        simb->rotulo = rotulo_mepa; \
          empilha(&pilha_simbs, simb); \
            simb->num_parametros=num_vars = 0;
#define desempilhaEImprime(pilha) \
  while ((simb = desempilhaMesmoNULL(pilha))) { debug_print("[desempilhaEImprime] simb->id = '%s'\n", simb->id); }

%}

%token PROGRAM ABRE_PARENTESES FECHA_PARENTESES
%token VIRGULA PONTO_E_VIRGULA DOIS_PONTOS PONTO
%token T_BEGIN T_END VAR IDENT ATRIBUICAO
%token NUMERO SOMA SUBTRACAO MULTIPLICACAO DIVISAO
%token OR AND MAIOR_QUE MENOR_QUE MAIOR_OU_IGUAL MENOR_OU_IGUAL IGUAL
%token IF THEN ELSE WHILE DO GOTO READ WRITE LABEL
%token PROCEDURE FUNCTION INTEGER BOOLEAN

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

programa    :               { geraCodigo (NULL, "INPP"); nivel_lexico = deslocamento = 0; }
              PROGRAM IDENT { simb = insereSimboloTab(tab, token, PROG, 0); empilha(&pilha_simbs, simb); }
              ABRE_PARENTESES lista_idents FECHA_PARENTESES PONTO_E_VIRGULA bloco
              PONTO         { geraCodigoDMEM(); geraCodigo (NULL, "PARA"); }
;

bloco       : rotulos parte_declara_vars  { empilhaAMEM(deslocamento);
                                            geraRotulo(&rotulo_mepa, &cont_rotulo, &pilha_rot);
                                            geraCodigoArgs (NULL, "DSVS %s", rotulo_mepa); }
              procs_funcs                 { geraCodigo (desempilha(&pilha_rot), "NADA"); }
              comando_composto
;

rotulos     : LABEL lista_nums PONTO_E_VIRGULA
            |
;
lista_nums  : NUMERO VIRGULA lista_nums
            | NUMERO
;

parte_declara_vars: var
;

var         : VAR         { deslocamento=0; }
              declara_vars
            |
;

declara_vars: declara_vars { num_vars=0; } declara_var
            | { num_vars=0; }declara_var
;

declara_var : lista_id_var DOIS_PONTOS tipo { geraCodigoArgs (NULL, "AMEM %d", num_vars); atrubuiPassagemTab(tab, T_VALOR, num_vars); }
              PONTO_E_VIRGULA
;

tipo        : INTEGER { tipo_aux = atribuiTiposTab(tab, T_INTEGER); }
            | BOOLEAN { tipo_aux = atribuiTiposTab(tab, T_BOOLEAN); }
            | IDENT   { tipo_aux = atribuiTiposTab(tab, T_UNKNOWN); } /* Tipo Desconhecido(ou nao tratado). #Sugestao: Adicionar Tipos Basicos: integer, boolean, char, real  (and maybe string)  */
;

lista_id_var: lista_id_var VIRGULA IDENT  { num_vars++; simb = insereSimboloTab(tab, token, VS, nivel_lexico); simb->deslocamento = deslocamento++; } /* insere ultima var na tabela de simbolos */
            | IDENT                       { num_vars++; simb = insereSimboloTab(tab, token, VS, nivel_lexico); simb->deslocamento = deslocamento++; } /* insere vars na tabela de simbolos */
;

lista_idents: lista_idents VIRGULA IDENT
            | IDENT
;

procs_funcs : PROCEDURE IDENT   { geraCodigoENPR(PROC); } /* #TODO Tratar parametros e seus tipos, num_parametros, etc */
              params_proc_func PONTO_E_VIRGULA bloco_proc_func
            | FUNCTION IDENT    { geraCodigoENPR(FUN); }
              params_proc_func  { simb->end_retorno = -4 - simb->num_parametros; } /* #TODO Conferir o deslocamento correto. */
              DOIS_PONTOS              /*  ^  #FIXME (simb->end_retorno) Procurar a posicao adequada (usar pilha??) */
              tipo PONTO_E_VIRGULA bloco_proc_func
            | 
;

bloco_proc_func: rotulos parte_declara_vars     { empilhaAMEM(deslocamento); geraRotulo(&rotulo_mepa, &cont_rotulo, &pilha_rot);
                                                  geraCodigoArgs (NULL, "DSVS %s", rotulo_mepa); }
              procs_funcs                       { geraCodigo (desempilha(&pilha_rot), "NADA"); }
              comando_composto PONTO_E_VIRGULA  { geraCodigoDMEM(); simb = desempilha(&pilha_simbs); removeSimbolosTab(tab, simb->id, simb->nivel_lexico);
                                                  geraCodigoArgs (NULL, "RTPR %d, %d", nivel_lexico--, simb->num_parametros); }  /* #TODO Verificar se a ordem e valor dos parametros esta correta */
              procs_funcs
;

params_proc_func: ABRE_PARENTESES
              lista_dec_param         { deslocamentosParamsTab(tab, simb->num_parametros); } /* #TODO voltar configurando deslocamentos -4, -5, etc */
              FECHA_PARENTESES    /* #TODO Tratar declaracao de parametros, ref e valor */
            |
;

lista_dec_param : lista_dec_param PONTO_E_VIRGULA
              { num_vars=0; } parametros_dec
            | { num_vars=0; } parametros_dec
            |
;

parametros_dec: VAR lista_id_par DOIS_PONTOS tipo { atrubuiPassagemTab(tab, T_REFERENCIA, num_vars); insereParamLista(simb, tipo_aux, T_REFERENCIA, num_vars); debug_print("[Parametro por referencia] simb->id = %d, num_vars = %d\n", simb->id, num_vars);  } /* #TODO Adicionar parametros na lista de parametros da funcao/proc. */
            | lista_id_par DOIS_PONTOS tipo       { atrubuiPassagemTab(tab, T_VALOR, num_vars); insereParamLista(simb, tipo_aux, T_VALOR, num_vars); debug_print("[Parametro por valor] simb->id = %d, num_vars = %d\n", simb->id, num_vars); }
;
lista_id_par: lista_id_par VIRGULA IDENT  { simb->num_parametros++; num_vars++; simb_aux = insereSimboloTab(tab, token, VS, nivel_lexico);
                                            debug_print("[insere param-last] simb->num_parametros = %d\n", simb->num_parametros); } /* insere ultimo Parametro na tabela de simbolos */
            | IDENT                       { simb->num_parametros++; num_vars++; simb_aux = insereSimboloTab(tab, token, VS, nivel_lexico);
                                            debug_print("[insere param] simb->num_parametros = %d\n", simb->num_parametros); } /* insere Parametros na tabela de simbolos */
;

comando_composto: T_BEGIN comandos_ T_END
;
comandos_   : comandos
            |
;

comandos    : comandos PONTO_E_VIRGULA comando
            | comando
;

comando     : NUMERO DOIS_PONTOS com_sem_rot  /* #TODO Tratar rotulo_pascal aqui */
            | comando_composto
            | { passagem = T_VALOR; } com_sem_rot
;

com_sem_rot : atrib_proc
            | com_condic
            | com_repetit
            | READ ABRE_PARENTESES lista_param_leit FECHA_PARENTESES
            | WRITE ABRE_PARENTESES lista_param_impr FECHA_PARENTESES
            | GOTO NUMERO /* #TODO Gerar Código; Acabar de escrever a regra */
;

lista_param_leit: lista_param_leit VIRGULA IDENT  { geraCodigoLEIT(); }
            | IDENT                               { geraCodigoLEIT(); } /* #TODO Verificar se 'simb' eh de tipo compativel com atribuicao e passado por referencia */
;

lista_param_impr: lista_param_impr VIRGULA IDENT  { geraCodigoIMPR(); }
            | IDENT                               { geraCodigoIMPR(); }  /* #TODO Verificar se 'simb' eh de tipo compativel com atribuicao e passado por referencia */
;

atrib_proc  : IDENT         { simb_aux = procuraSimboloTab(tab, token, nivel_lexico); empilhaTipoT(&pilha_tipos, simb_aux->tipo); }
              exec_ou_atrib /* #TODO Arrumar codigo: comparar tipos ao final. (pilha de identificadores?) suportar 'fn = 4;' */
;

exec_ou_atrib: ATRIBUICAO expressao { geraCodigoARMZI(simb_aux); }  /* #TODO Comparar tipos ao final. (pilha de identificadores?) suportar 'fn = 4;' */
            | exec_proc             { geraCodigoArgs (NULL, "CHPR %s, %d", simb_aux->rotulo, nivel_lexico); }    /* #TODO Tratar parametros do procedimento: p; p(); p(var1, var2); . */
;
exec_proc   : ABRE_PARENTESES { passagem = T_REFERENCIA; indice_param=0; } lista_de_parametros FECHA_PARENTESES { passagem = T_VALOR; }/* #TODO Verificar se nao eh funcao!! */
            | ABRE_PARENTESES FECHA_PARENTESES
            |
;
lista_de_parametros: lista_de_parametros VIRGULA expressao { indice_param++; } 
            | expressao { indice_param++; }
;

com_condic  : if_simples %prec LOWER_THAN_ELSE  { geraCodigo (desempilha(&pilha_rot), "NADA"); }
            | if_simples ELSE { rotulo_mepa=desempilha(&pilha_rot);
                                geraCodigoArgs (NULL, "DSVS %s", rotulo_mepa_aux);
                                geraCodigo (rotulo_mepa, "NADA"); }
              comando         { geraCodigo (desempilha(&pilha_rot), "NADA"); }
;

if_simples  : IF            { geraRotulo(&rotulo_mepa_aux, &cont_rotulo, &pilha_rot);
                              geraRotulo(&rotulo_mepa, &cont_rotulo, &pilha_rot); }
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

fator       : ABRE_PARENTESES expressao FECHA_PARENTESES                /* #TODO Adicionar f(n); */
            | id_ou_func
            | NUMERO  { geraCodigoArgs (NULL, "CRCT %d", atoi(token));
                        empilhaTipoT(&pilha_tipos, T_INTEGER); }
;

id_ou_func  : IDENT   { simb = procuraSimboloTab(tab, token, nivel_lexico);
                        geraCodigoCRVLI(simb); empilhaTipoT(&pilha_tipos, simb->tipo); }
//             | IDENT ABRE_PARENTESES lista_de_parametros FECHA_PARENTESES
//             | IDENT ABRE_PARENTESES FECHA_PARENTESES
// ;
// parametro   : IDENT
//             | expressao
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
  inicializaPilha(&pilha_simbs);

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

  // removeSimbolosTab(tab, "f1", 1);

  // imprimeTabSimbolos(tab); // #DEBUG
#endif
    desempilhaEImprime(&pilha_simbs);

  return 0;
}
