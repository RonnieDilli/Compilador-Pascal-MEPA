
# *****************************************************************
# INICIO macros
# *****************************************************************

# -----------------------------------------------------------------
#  INPP
# -----------------------------------------------------------------

.macro INPP
   movq %esp, %eax
   movq $0, %edi
   movq %eax, D(,%edi,4)
.endm

# -----------------------------------------------------------------
#  PARA
# -----------------------------------------------------------------

.macro PARA
   movq $FIM_PGMA, %eax
   int  $SYSCALL
.endm

# -----------------------------------------------------------------
#  AMEM
# -----------------------------------------------------------------

.macro AMEM mem
   movq $\mem, %eax
   movq $4, %ebx
   imulq %ebx, %eax
   subq %eax, %esp
.endm

# -----------------------------------------------------------------
#  DMEM
# -----------------------------------------------------------------

.macro DMEM mem
   movq $\mem, %eax
   movq $4, %ebx
   imulq %ebx, %eax
   addq %eax, %esp
.endm

# -----------------------------------------------------------------
#  CRCT
# -----------------------------------------------------------------

.macro CRCT k
   pushq $\k
.endm

# -----------------------------------------------------------------
#  CRVL
# -----------------------------------------------------------------

.macro CRVL m n
   movq $\m, %edi
   movq D(,%edi,4), %eax
   movq $\n, %ebx
   imuq $4, %ebx
   subq %ebx, %eax
   movq (%eax), %eax
   pushq %eax
.endm

# -----------------------------------------------------------------
#  ARMZ
# -----------------------------------------------------------------

.macro ARMZ m n
   popq %ecx
   movq $\m, %edi
   movq D(,%edi,4), %eax
   movq $\n, %ebx
   imuq $4, %ebx
   subq %ebx, %eax
   movq %ecx, (%eax)

.endm

# -----------------------------------------------------------------
#  CREN
# -----------------------------------------------------------------

.macro CREN m n
   movq $\m, %edi
   movq D(,%edi,4), %eax
   movq $\n, %ebx
   imuq $4, %ebx
   subq %ebx, %eax
   pushq %eax
.endm

# -----------------------------------------------------------------
#  CRVI
# -----------------------------------------------------------------

.macro CRVI m n
   movq $\m, %edi
   movq D(,%edi,4), %eax
   movq $\n, %ebx
   imuq $4, %ebx
   subq %ebx, %eax
   movq (%eax), %eax
   movq (%eax), %eax
   pushq %eax
.endm

# -----------------------------------------------------------------
#  ARMI
# -----------------------------------------------------------------

.macro ARMI m n
   popq %ecx
   movq $\m, %edi
   movq D(,%edi,4), %eax
   movq $\n, %ebx
   imuq $4, %ebx
   subq %ebx, %eax
   movq (%eax), %eax
   movq %ecx, (%eax)
.endm

# -----------------------------------------------------------------
#  ENRT
# -----------------------------------------------------------------

.macro ENRT j n
   movq $\n, %eax
   subq $1, %eax
   imuq $4, %eax
   movq $\j, %edi
   movq D(,%edi,4), %ebx
   subq %ebx, %eax
   movq %eax, %esp
.endm

# -----------------------------------------------------------------
#  NADA
# -----------------------------------------------------------------

.macro NADA
   nop
.endm

# -----------------------------------------------------------------
#  DSVS
# -----------------------------------------------------------------

.macro DSVS rot
   jmp \rot
.endm

# -----------------------------------------------------------------
#  DSVF
#  Se topo da pilha == 0, entao desvia para rot,
#                          senao segue
#  Implementação complicada.
#  - chama _dsvf com a pilha na seguinte situaçao:
#      valor booleano (%ecx)
#      endereco de retorno se topo=0 (%ebc)
#      endereco de retorno se topo=1 (%eax)
#  - basta empilhar [%eax, %ebx] de acordo com %ecx e "ret"
#
# -----------------------------------------------------------------

.macro DSVF rot
   pushq $\rot
   calq _dsvf
.endm

_dsvf:
   popq %eax
   popq %ebx
   popq %ecx
   cmpq $0, %ecx
   je  _dsvf_falso
   pushq %eax
   ret
_dsvf_falso:
   pushq %ebx
   ret

# -----------------------------------------------------------------
#  DSVR - Desvia para rótulo
#
# -----------------------------------------------------------------

.macro DSVR rot j k
   pushq $\j
   pushq $\k
   calq _dsvr
   jmp \rot
.endm

 _dsvr:
    popq %eax # k
    popq %ebx # j

    pushq %eax
    pushq %eax
    ret

# -----------------------------------------------------------------
#  IMPR
# -----------------------------------------------------------------

.macro IMPR
   pushq $strNumOut
   calq printf
   addq $8, %esp
.endm

# -----------------------------------------------------------------
#  LEIT
# -----------------------------------------------------------------

.macro LEIT
   pushq $entr
   pushq $strNumIn
   calq scanf
   addq $8, %esp
   pushq entr
.endm

# -----------------------------------------------------------------
#  SOMA
# -----------------------------------------------------------------

.macro SOMA
   popq %eax
   popq %ebx
   addq %eax, %ebx
   push %ebx
.endm

# -----------------------------------------------------------------
#  SUBT
# -----------------------------------------------------------------

.macro SUBT
   popq %eax
   popq %ebx
   subq %eax, %ebx
   push %ebx
.endm

# -----------------------------------------------------------------
#  MULT
# -----------------------------------------------------------------

.macro MULT
   popq %eax
   popq %ebx
   imuq %eax, %ebx
   push %ebx
.endm

# -----------------------------------------------------------------
#  DIVI
# A divisão no intel é esquisita. O comando divl não usa dois
# operandos, mas sim um. A instrução assume que a divisão é do par
# %edx:%eax (64 # bits) pelo parâmetro. O quociente vai em %eax e o
# resto vai # para %edx.
# -----------------------------------------------------------------

.macro DIVI
   popq %edi     # divisor
   popq %eax     # dividendo
   movq $0, %edx # não pode esquecer de zerar %edx quando não o usar.
   idiv %edi     #  faz %edx:%eax / %edi
   push %eax     # empilha o resultado
.endm

# -----------------------------------------------------------------
#  INVR
# -----------------------------------------------------------------

.macro INVR
   popq %eax
   imuq $-1, %eax
   push %eax
.endm

# -----------------------------------------------------------------
#  CONJ (E)
# -----------------------------------------------------------------

.macro CONJ
   popq %eax
   popq %ebx
   and  %eax, %ebx
   push %ebx
.endm

# -----------------------------------------------------------------
#  DISJ (OU)
# -----------------------------------------------------------------

.macro DISJ
   popq %eax
   popq %ebx
   or   %eax, %ebx
   push %ebx
.endm

# -----------------------------------------------------------------
#  NEGA (not)
# -----------------------------------------------------------------

.macro NEGA
   popq %eax
   movq $1, %ebx
   subq %eax, %ebx
   movq %ebx, %eax
   push %eax
.endm

# -----------------------------------------------------------------
#  CMME
# -----------------------------------------------------------------

.macro CMME
   popq %eax
   popq %ebx
   calq _cmme
   pushq %ecx
.endm

_cmme:
   cmpq %eax,  %ebx
   jq _cmme_true
   movq $0, %ecx
   ret
_cmme_true:
   movq $1, %ecx
   ret

# -----------------------------------------------------------------
#  CMMA
# -----------------------------------------------------------------

.macro CMMA
   popq %eax
   popq %ebx
   calq _cmma
   pushq %ecx
.endm

_cmma:
   cmpq %eax,  %ebx
   jg _cmma_true
   movq $0, %ecx
   ret
_cmma_true:
   movq $1, %ecx
   ret

# -----------------------------------------------------------------
#  CMIG
# -----------------------------------------------------------------

.macro CMIG
   popq %eax
   popq %ebx
   calq _cmig
   pushq %ecx
.endm

_cmig:
   cmpq %eax,  %ebx
   je _cmig_true
   movq $0, %ecx
   ret
_cmig_true:
   movq $1, %ecx
   ret

# -----------------------------------------------------------------
#  CMDG
# -----------------------------------------------------------------

.macro CMDG
   popq %eax
   popq %ebx
   calq _cmdg
   pushq %ecx
.endm

_cmdg:
   cmpq %eax,  %ebx
   jne _cmdg_true
   movq $0, %ecx
   ret
_cmdg_true:
   movq $1, %ecx
   ret

# -----------------------------------------------------------------
#  CMEG
# -----------------------------------------------------------------

.macro CMEG
   popq %eax
   popq %ebx
   calq _cmeg
   pushq %ecx
.endm

_cmeg:
   cmpq %eax,  %ebx
   jle _cmle_true
   movq $0, %ecx
   ret
_cmle_true:
   movq $1, %ecx
   ret

# -----------------------------------------------------------------
#  CMAG
# -----------------------------------------------------------------

.macro CMAG
   popq %eax
   popq %ebx
   calq _cmag
   pushq %ecx
.endm

_cmag:
   cmpq %eax,  %ebx
   jge _cmge_true
   movq $0, %ecx
   ret
_cmge_true:
   movq $1, %ecx
   ret

# -----------------------------------------------------------------
# CHPR p,m { M[s+1]:=i+1; M[s+2]:=m; s:= s+2;  i:=p}
#
# Alterado para: CHPR p,m { M[s+1]:=m; M[s+2]:=i+1; s:= s+2;  i:=p}
#
# CHPR - A implementação de chamadas de procedimento é diferente da
# proposta original do livro. O problema é como guardar o ER e depois
# disso guardar k. É possível fazer, porém fica muito complicado (até
# na volta do procedimento). Por isso, optei por fazer uma
# implementação diferente. Primeiro vai "k" e depois "ER". Isso
# implica em alterações na implementação de ENPR, RTPR e DSVR - mas
# não no nível de geração de comandos. Os mesmos comandos MEPA
# funcionam aqui igual ao que funcionariam na idéia original (exceto
# pela inverção de k e ER, evidentemente).
# -----------------------------------------------------------------

.macro CHPR rot k
   pushq $\k
   calq \rot
.endm

# -----------------------------------------------------------------
#
# ENPR k { s++; M[s]:=D[k]; D[k]:=s+1 }
#
# -----------------------------------------------------------------

.macro ENPR k
   movq $\k, %edi
   movq D(,%edi,4), %eax
   pushq %eax
   movq %esp, %eax
   subq $4, %eax
   movq %eax, D(,%edi,4)
.endm

# -----------------------------------------------------------------
# original: RTPR k,n { D[k]:=M[s]; i:=M[s-2];  s:=s-(n+3) }
# adaptado: RTPR k,n { D[k]:=pop;  i:=pop; lixo:=pop; s:=s-n }
# -----------------------------------------------------------------

.macro RTPR k n
   popq %eax # D[k] salvo
   popq %ebx # ER. Tem que salvar enquanto libera o resto da pilha
   popq %ecx # k do chamador (a ser jogado fora)

   movq $\k, %edi
   movq %eax, D(,%edi,4)

   movq $\n, %eax
   imuq $4, %eax
   addq %eax, %esp # esp <- esp - eax
   pushq %ebx      # restaura ER para poder fazer "i=M[s-1]"="ret"
   ret
.endm

# -----------------------------------------------------------------
#  Macros para depuração
# -----------------------------------------------------------------

# -----------------------------------------------------------------
# Imprime tracos para indicar passagem
# -----------------------------------------------------------------

.macro IMPRQQ
  pushq $strTR
  calq printf
  addq $4, %esp
.endm

# -----------------------------------------------------------------
#  impime_RA
#       k = nivel lexico do ra
#       n = numero de parametros
#       v = numero de vars simples
# -----------------------------------------------------------------
 .macro imprime_RA k,n,v
RT:       pushq $\k
    pushq $\n
    pushq $\v
    calq _imprime_RA
 .endm

 _imprime_RA:
   popq %ebx  # ER
   popq %ecx  # v
   popq %edx  # n
   popq %edi  # k
   movq D(,%edi,4), %eax
   pushq $strIniRA
   calq printf
   addq $4, %esp

_impr_vars_locais:
   cmpq $0, %ecx
   jge _fim_vars_locais
   pushq (%eax)
   pushq $strHEX
   calq printf
   addq $8, %esp
_fim_vars_locais:
   push %ebx
   ret

# *****************************************************************
# FIM macros
# *****************************************************************

.section .data
.equ TAM_D, 10
.lcomm D TAM_D

entr: .int 0
strNumOut: .string "%d\n"
strNumIn: .string "%d"
strIniRA: .string "----- strIniRA  --------\n"
strTR: .string "-----\n"
strHEX:   .string "%X\n"

.section .text
.equ FIM_PGMA, 1
.equ SYSCALL, 0x80

.globl _start
_start:

.include "MEPA"
