#define MAX_TAB 100   /* Tamanho maximo de Simbolos na TabSimbDin  */
#define MAX_ID  255   /* Tamanho maximo da string 'id' na TabSimbDin  */
#define ROTULO_TAM 7  /* Tamanho maximo do 'char' para o rotulo no MEPA  */

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
      char rotulo[ROTULO_TAM];
      ListaParamT *lista_param;
    };
  };
} SimboloT;

/*  Estrutura de dados da Tabela de Simbolos  */
typedef struct TabelaSimbT {
  SimboloT elemento[MAX_TAB];
  int num_elementos;
} TabelaSimbT;

/*  Estrutura com variaveis auxiliares  */

int procuraElementoTab(TabelaSimbT *, char *);

int insereElementoTab(TabelaSimbT *, char *);

int atribuiTiposTab(TabelaSimbT *, TipoT, int);

int imprimeElementosTab(TabelaSimbT *);
