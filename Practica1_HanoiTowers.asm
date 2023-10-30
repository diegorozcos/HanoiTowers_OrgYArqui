.text
main:
    addi s1, zero, 3  # Inicializa s1 con 3, que representa el número de discos
    addi a1, zero, 1  # Inicializa a1 con 1
    slli a1, a1, 28   # Desplaza a1 a la izquierda para obtener la dirección de la primera torre
    addi t0, zero, 1  # Inicializa t0 con 1
    slli t0, t0, 16   # Desplaza t0 a la izquierda para definir una dirección de memoria
    add a1, a1, t0   # Calcula la dirección de la primera torre
    addi t0, zero, 3  # Inicializa t0 con 3, que representa el número de discos
    add t1, zero, a1  # Copia la dirección de la primera torre a t1
    jal iniciarTorre  # Salta a la función iniciarTorre
    sw zero, 0(sp)  # Almacena 0 en la pila
    addi sp, sp, 4  # Ajusta el puntero de pila
    addi a3, a3, 4  # Incrementa a3 en 4 para obtener la dirección de la tercera torre
    addi t0, zero, 3  # Inicializa t0 con 3
    addi t5, t0, -1  # Inicializa t5 con 2
    slli t5, t5, 2  # Multiplica t5 por 4
    add a2, a2, t5  # Calcula la dirección de la segunda torre
    addi a2, a2, 4  # Incrementa a2 en 4 bytes
    add a3, a3, t5  # Calcula la dirección de la tercera torre
    addi a3, a3, 4  # Incrementa a3 en 4 bytes
    add t1, zero, a1  # Copia la dirección de la primera torre a t1
    add t2, zero, a2  # Copia la dirección de la segunda torre a t2
    add t3, zero, a3  # Copia la dirección de la tercera torre a t3
    jal hanoi  # Salta a la función hanoi
    jal fin  # Salta a la función fin

iniciarTorre:
    beq t0, zero, torre2  # Comprueba si t0 (número de discos) es igual a 0 y salta a torre2 si es cierto
    addi sp, sp, -4  # Reserva espacio en la pila
    sw ra, 0(sp)  # Guarda el valor de ra (registro de retorno) en la pila
    addi t2, t2, 1  # Incrementa t2 (torre de origen)
    sw t2, 0(t1)  # Almacena el valor de la torre de origen en la dirección apuntada por t1
    addi t1, t1, 4  # Incrementa t1 para apuntar a la siguiente posición de memoria
    addi t0, t0, -1  # Decrementa t0 (número de discos) en 1
    jal iniciarTorre  # Llama recursivamente a iniciarTorre
salirIni:
    lw ra, 4(sp)  # Carga el valor de ra desde la pila
    addi t1, t1, 4  # Incrementa t1 para apuntar a la siguiente posición de memoria
    add a3, zero, t1  # Copia la dirección de t1 en a3
    add t5, zero, zero  # Inicializa t5 con 0
    sw t5, 0(sp)  # Almacena 0 en la pila
    addi sp, sp, 4  # Ajusta el puntero de pila
    jalr ra  # Retorna desde la función anterior

torre2:
    add a2, zero, t1  # Copia la dirección de t1 en a2 (torre de origen)
    addi t1, t1, 4  # Incrementa t1 para apuntar al inicio de la segunda torre
    lw ra, 4(sp)  # Carga el valor de ra desde la pila
    add t5, zero, zero  # Inicializa t5 con 0
    sw t5, 0(sp)  # Almacena 0 en la pila
    sw t5, 4(sp)  # Almacena 0 en la pila
    addi sp, sp, 4  # Ajusta el puntero de pila
    jalr ra  # Retorna desde la función anterior

hanoi:
    bne t0, zero, hanoiLoop  # Comprueba si t0 (número de discos) es diferente de 0 y salta a hanoiLoop si es cierto
    jalr ra  # Retorna desde la función hanoi

hanoiLoop:
    addi sp, sp, -8  # Reserva espacio en la pila para la recursión
    sw ra, 4(sp)  # Guarda el valor de ra en la pila
    sw t0, 0(sp)  # Guarda el valor de t0 en la pila
    addi t0, t0, -1  # Decrementa t0 (número de discos) en 1
    add t4, zero, t2  # Copia t2 en t4
    add t2, zero, t3  # Copia t3 en t2
    add t3, zero, t4  # Copia t4 en t3
    jal hanoi  # Llama recursivamente a hanoi

    # Mover disco
    lw t0, 0(sp)  # Carga el valor de t0 desde la pila
    lw ra, 4(sp)  # Carga el valor de ra desde la pila
    sw zero, 0(sp)  # Borra los valores de la pila
    sw zero, 4(sp)  # Borra los valores de la pila
    addi sp, sp, 8  # Ajusta el puntero de pila
    add t4, zero, t2  # Copia t2 en t4
    add t2, zero, t3  # Copia t3 en t2
    add t3, zero, t4  # Copia t4 en t3
    addi t3, t3, -4  # Realiza un ajuste en la dirección de memoria
    lw t4, 0(t1)  # Carga el valor de la torre de origen
    sw t4, 0(t3)  # Almacena el valor en la nueva ubicación
    sw zero, 0(t1)  # Borra el valor en la torre de origen
    addi t1, t1, 4  # Incrementa t1 para apuntar a la siguiente posición de memoria

    # Continuación de la recursión
    addi sp, sp, -8  # Reserva espacio en la pila
    sw ra, 4(sp)  # Guarda el valor de ra en la pila
    sw t0, 0(sp)  # Guarda el valor de t0 en la pila
    add t4, zero, t2  # Copia t2 en t4
    add t2, zero, t1  # Copia t1 en t2
    add t1, zero, t4  # Copia t4 en t1
    jal hanoi  # Llama recursivamente a hanoi

    # Restauración del contexto anterior
    lw t0, 0(sp)  # Carga el valor de t0 desde la pila
    lw ra, 4(sp)  # Carga el valor de ra desde la pila
    sw zero, 0(sp)  # Borra los valores de la pila
    sw zero, 4(sp)  # Borra los valores de la pila
    addi sp, sp, 8  # Ajusta el puntero de pila
    add t4, zero, t2  # Copia t2 en t4
    add t2, zero, t1  # Copia t1 en t2
    add t1, zero, t4  # Copia t4 en t1
    jalr ra  # Retorna desde la función anterior

fin:
    add zero, zero, zero  # Fin del programa
