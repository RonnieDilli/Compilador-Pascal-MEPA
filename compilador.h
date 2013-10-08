/* -------------------------------------------------------------------
 *            Arquivo: compilaodr.h
 * -------------------------------------------------------------------
 *              Autor: Bruno Muller Junior
 *               Data: 08/2007
 *      Atualizado em: [15/03/2012, 08h:22m]
 *
 * -------------------------------------------------------------------
 *
 * Tipos, protótipos e vaiáveis globais do compilador
 *
 * ------------------------------------------------------------------- */

#define TAM_TOKEN 16

#ifdef DEBUG
#define debug_print(fmt, ...) \
  fprintf(stderr, "#DEBUG [%s] ", __func__); \
    fprintf(stderr, fmt, __VA_ARGS__);
#else
#define debug_print(...) {}
#endif

char buf[1023];
#define geraCodigoArgs(rot, fmt, ...) \
  sprintf(buf, fmt, __VA_ARGS__); \
    geraCodigo(rot, buf);

typedef enum simbolos {
  simb_program, simb_var, simb_begin, simb_end,
  simb_identificador, simb_numero,
  simb_ponto, simb_virgula, simb_ponto_e_virgula, simb_dois_pontos,
  simb_atribuicao, simb_abre_parenteses, simb_fecha_parenteses,
  simb_soma, simb_subtracao, simb_multiplicacao, simb_divisao,
  simb_or, simb_and, simb_maior_que, simb_menor_que,
  simb_if, simb_then, simb_else, simb_while, simb_do, simb_go_to,
  simb_procedure, simb_function, simb_integer, simb_boolean,
} simbolos;

/* -------------------------------------------------------------------
 * variáveis globais
 * ------------------------------------------------------------------- */

extern simbolos simbolo, relacao;
extern char token[TAM_TOKEN];
extern int nivel_lexico;
extern int desloc;
extern int nl;

simbolos simbolo, relacao;
char token[TAM_TOKEN];

/* -------------------------------------------------------------------
 * Declaracao das funcoes
 * ------------------------------------------------------------------- */

void geraCodigo (char*, char*);
int imprimeErro ( char*);

/* -------------------------------------------------------------------
 * Fixes (erros/warnings na compilacao)
 * ------------------------------------------------------------------- */

void yyerror (char *); /*  Arruma erro de compilacao do ProjetoBase  */

/*  Arruma warning na compilacao do ProjetoBase  */
/* Default declaration of generated scanner - a define so the user can
 * easily add parameters.
 */
#ifndef YY_DECL
#define YY_DECL_IS_OURS 1

extern int yylex (void);

#define YY_DECL int yylex (void)
#endif /* !YY_DECL */
