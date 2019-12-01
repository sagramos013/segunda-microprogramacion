.386
.MODEL flat, stdcall
option casemap:none

;includes
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\masm32rt.inc	;Deja imprimir valores que haya en registros
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc

;librerias
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\gdi32.lib


.data

openerr DB "Error, archivo no existe", 0
file DB "a.txt", 0
err_cap DB "Error", 0
readerr DB "Problema al abrir archivo", 0
strString DB "hola", 0;palabra a encontrar en el archivo de texto
len1 Equ $ - strString - 1

strCap1 DB "Comparación exitosa", 0
strMsg1 DB "coinsidencia", 0
strCap2 DB "Comparación fallida", 0
strMsg2 DB "no hay coinsidencia", 0

.data?

fhandle DD ?
bytesread DD ?
bytesBuf BYTE 50 DUP(?)
.code

start:

    ;
    Push 0
    Push FILE_ATTRIBUTE_NORMAL
    Push OPEN_EXISTING
    Push 0
    Push 0
    Push GENERIC_READ
    Push Offset file
    Call CreateFile

    Mov fhandle, Eax
    Cmp Eax, 0FFFFFFFFh

    Jnz file_opened

    ;error al encontrar archivo
    Push MB_OK
    Push Offset err_cap
    Push Offset openerr
    Push 0
    Call MessageBox

    Jmp end_

    file_opened:

    ; leer el archivo
    Push 0
    Lea Eax, bytesread
    Push Eax
    Push SIZEOF bytesBuf
    Lea Eax, bytesBuf
    Push Eax
    Push fhandle
    Call ReadFile

    Cmp bytesread, 0
    Jnz bytes_have_been_read

    ;error mientras se lee archivo
    Push MB_OK
    Push Offset err_cap
    Push Offset readerr
    Push 0
    Call MessageBox

    Jmp end_

    bytes_have_been_read:

    ; comparar el tamaño de las cadenas, si no son iguales entonces no compara las cadenas
    Mov Eax, len1
    Mov Ebx, bytesread
    Cmp Eax, Ebx
    Jnz strings_dont_match

    ; establece Esi en la dirección de memoria de strString1
    ; establezca Ecx (para Repz) en strString1 longitud incluyendo 0 terminador de cadena
    ; configura Edi para la dirección de strString2
    Mov Esi, Offset strString
    Mov Ecx, len1 + 1
    Mov Edi, Offset bytesBuf

       ; Repita hasta que los valores en la memoria de [EDI] y [ESI] sean diferentes, o Ecx = 0
    Repz Cmpsb

    Cmp Ecx, 0

   
    Jz strings_match
    Jmp strings_dont_match

SetTextColor proc fore:DWORD,back:DWORD
    LOCAL hStdOut:DWORD
    invoke GetStdHandle,STD_OUTPUT_HANDLE
    mov   hStdOut,eax
    mov   eax,back
    shl   eax,4
    or    eax,fore
    invoke SetConsoleTextAttribute,hStdOut,eax
    ret
SetTextColor endp


strings_match:;si encuentra alguna coinsidencia

	Invoke SetTextColor,1,0;llamamos el procedimiento SetTextColor y le mandamos los parametros 1 y 0 para el cambio del color de la letra y fondo
	Invoke StdOut, addr  bytesBuf; mostramos el contenido del archivo
    Push MB_OK
    Push Offset strCap1
    Push Offset strMsg1
    Push 0
    Call MessageBox
    Jmp end_close_file

strings_dont_match:;no encontro ninguna coinsidencia

    ; Strings don't match MessagBox Error
    Push MB_OK
    Push Offset strCap2
    Push Offset strMsg2
    Push 0
    Call MessageBox

end_close_file:

    Push fhandle
    Call CloseHandle

end_:
	Invoke SetTextColor,0,0
    Push 0
    Call ExitProcess

end start

;
  ;.data?
    ;hFile dd ?
    ;flen dd ?
    ;bRed dd ?
    ;pMem dd ?
;
  ;.code
;
  ;Main:
;
    ;mov hFile, fopen("C:\Users\SAGRAMOS\Desktop\a.txt");abrimos el archivo
    ;mov flen,  fsize(hFile);obtener el tamaño
    ;mov pMem,  alloc(flen);alojamos en memoria
    ;mov bRed,  fread(hFile,pMem,flen);leemos el archivo en un buffer 
;
    ;print pMem,13,10; mostramos el contenido del archivo 
;
    ;fclose hFile;cerrar archivo
    ;free pMem; liberar memoria
;
    ;invoke ExitProcess,0; fin
;
  ;end Main
