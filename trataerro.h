typedef enum ErroT {

  /* Retorno 0 -> Nao ha erro (UNIX default) */
  SEM_ERRO=0,

  /* Erros Sintaticos */
  ERRO_SINTATICO=40, ERRO_SINT_IDENT_NAO_ENC=41, ERRO_TIPO=42,

  /* Alocacao mal sucedida */
  ERRO_ALOCACAO, ERRO_TAB_NAO_ALOC,

  /* Identificadores */
  ERRO_IDENT_JA_DEC, ERRO_SIMB_NAO_ENC,

  /* Lista de Parametros */
  ERRO_LISTA_PARAM_NAO_ALOC, ERRO_PARAM_NAO_ENC, ERRO_MAX_PARAM,
  
  /* PILHA */
  ERRO_PILHA_N_EXISTE, ERRO_PILHA_VAZIA, ERRO_PILHA_TAM_EXCED,

  /* WARNING */  
  WARN_IDENT_JA_DEC,

} ErroT;

int trataErro(ErroT, char*);