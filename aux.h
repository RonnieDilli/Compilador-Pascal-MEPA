
/*  Define tamanho maximo do rotulo  */
#define ROTULO_TAM 7

typedef enum OperacaoT {
  OP_COMPARACAO, OP_ATRIBUICAO,
} OperacaoT;

int geraRotulo(char **, int *, PilhaT *);

int empilhaTipoT(PilhaT *, TipoT);

int confereTipo(OperacaoT, TipoT, TipoT);
