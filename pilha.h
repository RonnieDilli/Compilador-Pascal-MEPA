
/*  Estrutura de dados de Pilha  */
#define PILHA_TAM 255

typedef struct PilhaT {
  void *elemento[PILHA_TAM];
  int num_elementos;
} PilhaT;

int inicializaPilha(PilhaT *);

int empilha(PilhaT *pilha, void *);

void * desempilha(PilhaT *);
