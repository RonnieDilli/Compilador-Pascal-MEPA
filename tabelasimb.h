#define TAM_LISTA_PARAM 255

typedef enum CategoriaT {
  FUN, PF, PROC, PROG, ROT, VS
} CategoriaT;

typedef enum TipoT {
  T_BOOLEAN=42, T_CHAR, T_INTEGER, T_REAL, T_VOID, T_PROCEDURE, T_FUNCTION, T_UNKNOWN=999, T_UNSET=0
} TipoT;

/*  Estrutura de dados da Lista de Parametros usado por Funcoes e Procedimentos  */
typedef enum PassagemT {
  T_REFERENCIA=1, T_VALOR=2
} PassagemT;

typedef struct ParametroT {
  TipoT tipo;
  PassagemT passagem;
} ParametroT;

typedef struct SimboloT {
  char id[TAM_TOKEN];
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
      ParametroT *lista_param;
    };
  };
  struct SimboloT *ant, *prox, *pai;
} SimboloT;

/*  Estrutura de dados da Tabela de Simbolos  */
typedef struct TabelaSimbT {
  SimboloT *primeiro, *ultimo;
  int num_simbolos;
} TabelaSimbT;

/*  Estrutura com variaveis auxiliares  */

SimboloT *procuraSimboloTab(TabelaSimbT *, char *, int);

SimboloT *retornaSimboloTab(TabelaSimbT *, char *, int );

SimboloT *insereSimboloTab(TabelaSimbT *, char *, CategoriaT, int);

int removeSimboloTab(TabelaSimbT *, SimboloT *);

int removeFPSimbolosTab(TabelaSimbT *, SimboloT *);

int atribuiTipoSimbTab(TabelaSimbT *, TipoT, char *);

int atribuiTiposTab(TabelaSimbT *, TipoT);

int deslocamentosParamsTab(TabelaSimbT *, int);

int atribuiPassagemTab(TabelaSimbT *, PassagemT, int);

int insereParamLista(SimboloT  *, TipoT, PassagemT, int);

int imprimeTabSimbolos(TabelaSimbT *);
