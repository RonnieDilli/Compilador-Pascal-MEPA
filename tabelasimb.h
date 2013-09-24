
/*  Estrutura de dados da Tabela de Simbolos  */
#define MAX_TAB 100
#define MAX_ID  255

typedef enum CategoriaT {
  VS, TEST
} CategoriaT;

typedef enum TipoT {
  T_INTEGER, T_BOOLEAN, T_CHAR, T_VOID, T_FUNCTION, T_UNKNOWN=999
} TipoT;

typedef struct ElementoT {
  char id[MAX_ID];
  CategoriaT cat;
  int nivellexico, deslocamento;
  TipoT tipo;
} ElementoT;

typedef struct TabelaSimbT {
  ElementoT elemento[MAX_TAB];
  int num_elementos;
} TabelaSimbT;

/*  Estrutura com variaveis auxiliares  */

int procuraElementoTab(TabelaSimbT *, char *);

int insereElementosTab(TabelaSimbT *, char *);

int atribuiTiposTab(TabelaSimbT *, TipoT, int);

int imprimeElementosTab(TabelaSimbT *);

// int criaTabela(TabelaSimb *);
// int removeElemento(char *);
