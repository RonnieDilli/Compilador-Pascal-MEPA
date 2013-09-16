
/*  Estrutura de dados da Tabela de Simbolos  */
#define MAX_TAB 100

typedef enum CategoriaT {
  VS, TEST
} CategoriaT;

typedef enum TipoT {
  INT, BOOLEAN, CHAR, VOID, FUNCTION
} TipoT;

typedef struct ElementoT {
  char id[255];
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

int imprimeElementosTab(TabelaSimbT *, char *);

int insereElementosTab(TabelaSimbT *, int);


// int criaTabela(TabelaSimb *);
// int removeElemento(char *);

