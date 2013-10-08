#define ROTULO_TAM 7  /* Tamanho maximo do 'char' para o rotulo no MEPA  */

typedef enum OperacaoT {
  OP_COMPARACAO, OP_ATRIBUICAO,
} OperacaoT;

int geraRotulo(char **, int *, PilhaT *);

int empilhaTipoT(PilhaT *, TipoT);

int confereTipo(OperacaoT, TipoT, TipoT);
