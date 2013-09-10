
/*  Estrutura de dados da Tabela de Simbolos  */
typedef struct elemento *TabelaSimb;
typedef struct elemento {
  int identificador, categoria, nivellexico, deslocamento, tipo;
  TabelaSimb anterior, proximo;
} elemento;

/*  Estrutura com variaveis auxiliares  */


int criaTabela(TabelaSimb *);

TabelaSimb * procuraElemento(char *);

TabelaSimb * insereElemento();

int removeElemento(char *);

