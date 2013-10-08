#define MAX_TAB 100   /* Tamanho maximo de Simbolos na TabSimbDin  */
#define MAX_ID  255   /* Tamanho maximo da string 'id' na TabSimbDin  */

typedef enum CategoriaT {
  FUN, PF, PROC, ROT, VS
} CategoriaT;

typedef enum TipoT {
  T_BOOLEAN, T_CHAR, T_INTEGER, T_REAL, T_VOID, T_PROCEDURE, T_FUNCTION, T_UNKNOWN=999
} TipoT;

/*  Estrutura de dados da Lista de Parametros usado por Funcoes e Procedimentos  */
typedef enum PassagemT {
  T_REFERENCIA, T_VALOR
} PassagemT;

typedef struct ParametrosT {
  TipoT tipo;
  PassagemT passagem;
} ParametrosT;

typedef struct ListaParamT {
  ParametrosT *parametros;
  struct ListaParamT *ant, *prox;
} ListaParamT;

/*  Estrutura dos Simbolos  */
typedef struct SimboloT {
  char id[MAX_ID];
  CategoriaT categoria;

  int nivel_lexico;
  TipoT tipo;

  union {
    int deslocamento;
    int end_retorno;
  };

  union {
    PassagemT passagem;
    struct {
      int num_parametros;
      char *rotulo;
      ListaParamT *lista_param;
    };
  };
} SimboloT;

/*  Estrutura de dados da Tabela de Simbolos  */
typedef struct TabelaSimbT {
  SimboloT simbolo[MAX_TAB];
  int num_simbolos;
} TabelaSimbT;

/*  Estrutura com variaveis auxiliares  */

int procuraSimboloTab(TabelaSimbT *, char *);

int insereSimboloTab(TabelaSimbT *, char *, CategoriaT, int);

int atribuiTipoSimbTab(TabelaSimbT *, char *, TipoT);

int atribuiTiposTab(TabelaSimbT *, TipoT, int);

int imprimeTabSimbolos(TabelaSimbT *);
