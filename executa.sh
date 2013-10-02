# MacOS X Detection
UNAME_S=$(uname -s)

if [ $UNAME_S == Darwin ]; then  # Assume Mac OS X
  HOST="_APPLE"
fi

if [ $HOST == "_APPLE" ]; then
  AS_x86_ARGS="-arch i386"
else
  AS_x86_ARGS="--32"  # Funciona no Linux GNU Assembler versao 2.22
fi


echo "compilando..."
make -f Makefile
echo "gerando MEPA..."
./compilador $1
if [ $? == 0 ]; then
    echo "montando..."
    as mepa.s -o mepa.o $AS_x86_ARGS
    if [ $? == 0 ]; then
        echo "ligando..."
        ld mepa.o -o mepa -lc -dynamic-linker /lib/ld-linux.so.2 -m elf_i386
        if [ $? == 0 ]; then
            echo "Executando"
            ./mepa
        fi
    fi
    echo "FIM"
fi
