#define ROTULO_TAM 7  /* Tamanho maximo do 'char' para o rotulo no MEPA  */

typedef enum OperacaoT {
  OP_CALCULO, OP_COMPARACAO, OP_ATRIBUICAO,
} OperacaoT;

int geraRotulo(char **, int *, PilhaT *);

int empilhaTipoT(PilhaT *, TipoT);

int confereTipo(PilhaT *, OperacaoT, TipoT);
