.model small
.stack
.data
    mult db 1
    mult2 db 1
    cont db 0
    num db 0
    num2 db 0
    aux db 0
    aux2 db 0
    d1 db 0
    d2 db 0
    d3 db 0
    d4 db 0
    d5 db 0

    msg db 10,13,7,'Presione Enter para ingresar el numero o llegue al valor maximo permitido.  Ingrese un numero: ','$'

.code

    mov ax, seg @data
    mov ds, ax

    mov ah, 09h;mostrar mensaje
    lea dx, msg
    int 21h

    ciclo:;ciclo que captura el numero
        cmp cont, 5;contador hasta 5
        je alreves
        
        xor ax, ax ;limpiamos

        mov ax, 01h;captura de un numero
        int 21h

        cmp ax, 13; se valida si presiono enter
        je alreves ;si presiono Enter hacemos un salto si no sigue ejecutando la siguiente instruccion

        sub ax, 30h;convertir en numero, restar 30h
        
        mov bx, mult;multiplicador
        mul bx;multimplicamos el numero capturado por nuestro multiplicador
        add ax, num ;los sumamos

        mov num, ax; se guarda la suma

        ;aumentamos el valor del multiplicador
        mov ax, mult;multiplicador
        mov bx, 10;multiplicacion fija  *10
        mul bx
        mov mult, ax

        inc cont;cont++
    jmp ciclo




    alreves:; ciclo que convierte numero al reves
    cmp cont, 0;contador
        je inicio
        xor ax, ax;limpiamos

        mov bx, mult
        mov ax, num
        div bx ;al = num/mult
        mov aux, al

        ;calcular digito
        mov ax, aux
        mov bx, mult2
        mul bx;multiplicamos
        add ax, num2;agrupamos el resultado
        mov num2, ax;guardamos el resultado

        ;sacar digito del numero
        mov ax, aux
        mov bx, mult
        mul bx;multiplicamos
        mov aux, ax

        mov ax, num
        sub ax, aux;restamos
        mov num ax;guaramos el numero sin el digito que restamos

        ;decrementamos el valor del divisor /10
        mov bx, 10
        mov ax, mult;mult se volvera el divisor
        div bx ;al = ax/bx
        mov mult, al

        ;aumentamos el valor del multiplicador
        mov ax, mult2;multiplicador
        mov bx, 10;multiplicacion fija  *10
        mul bx
        mov mult, ax

        dec cont;cont--
    jmp alreves

       
inicio:
mov ax,num ; asigno un valor de 3 digitos en decimal al registro AL
aam ;ajusta el valor en AL por: AH=alta Y AL=baja

mov aux, al ;3digitos
mov aux2, ah ;2digitos


mov al,aux ; asigno un valor de 3 digitos en decimal al registro AL
aam ;ajusta el valor en AL por: AH=alta Y AL=baja
mov d1,al ; Respaldo 
mov al,ah ;muevo lo que tengo en AH a AL para poder volver a separar los números

aam ; separa lo qe hay
mov d3,ah ;respaldo
mov d2,al ;respaldo

mov al,aux2 ;muevo lo que tengo en aux2 a AL para poder volver a separar los números

aam ; separa lo que hay
mov d5,ah ;respaldo
mov d4,al ;respaldo

;Imprimos los tres valores empezando por centenas, decenas y unidades.

mov ah,02h

mov dl,d5
add dl,30h ; se suma 30h a dl para imprimir el numero real.
int 21h

mov dl,d4
add dl,30h
int 21h

mov dl,d3
add dl,30h
int 21h

mov dl,d2
add dl,30h
int 21h

mov dl,d1
add dl,30h
int 21h

;Termina programa
mov ah,04ch
int 21h
end
