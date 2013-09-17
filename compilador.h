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

#define DEBUG 1

#define debug_print(fmt, ...) \
  if (DEBUG) fprintf(stderr, "#DEBUG [%s] ", __func__); \
    if (DEBUG) do { fprintf(stderr, fmt, __VA_ARGS__); } while (0)

typedef enum simbolos { 
  simb_program, simb_var, simb_begin, simb_end, 
  simb_identificador, simb_numero,
  simb_ponto, simb_virgula, simb_ponto_e_virgula, simb_dois_pontos,
  simb_atribuicao, simb_abre_parenteses, simb_fecha_parenteses,
  simb_soma, simb_subtracao, simb_multiplicacao, simb_divisao,
  simb_or, simb_and, simb_maior_que, simb_menor_que,
  simb_if, simb_then, simb_else, simb_while, simb_do, simb_go_to,
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
 * funcoes auxiliares
 * ------------------------------------------------------------------- */

void yyerror (char *s); /*  Arruma erro de compilacao do ProjetoBase  */
