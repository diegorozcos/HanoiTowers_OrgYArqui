# Diego Arturo Orozco Sánchez   Isaac Ramírez Robles Castillo
.text
main:
	# // Aquí se inician los valores que se necesitan para que todo funcione
	lui s1, 0x10010		# Primera dirección de la RAM para inicializar la torre 1
	addi t1, zero, 1	# Caso default del problema de Hanoi
	addi t2, zero, 8	# Cantidad de discos a utilizar en el programa
	slli s0, t2, 2		# Equivalente a multiplicar por 4
	add s2, s1, s0		# Torre auxiliar
	add s3, s2, s0		# Torre destino
	addi t3, zero, 0	# Variable para contar los movimientos que se realizan
	addi s4, zero, 1	# Variable para la i del ciclo for para llenar los discos (empieza en 1)
	addi s5, zero, 0	# Almacenar ra
	
	addi s2, s2, -4
	addi s3, s3, -4		# Mueve el apuntador a ambas torres (la auxiliar y la destino)
	
	for:
		blt t2, s4, endfor	# for (int i = 1; i < n; i++)
		sw s4, 0(s1)		# Simula el printf para mostrar los discos
		addi s1, s1, 4		# Avanza 4 bits para representar la siguiente posición
		addi s2, s2, 4
		addi s3, s3, 4
		addi s4, s4, 1		# i++ del ciclo
		jal for
	
	endfor:
		addi s1, s1, -4		# Apuntador a la primera torre
		
		jal hanoi		# Se llama a hanoi después de inicializar los discos
		
		jal exit		# Sale del algoritmo

hanoi:
	# Primero buscamos tener el caso default donde solo tenemos un disco
	bne t2, t1, else	# Cuando n != 1
	add s5, zero, ra	# Guarda el valor en el ra
	
	# swapDisk(src_rod, to_rod)
	sw zero, 0(s1) 		# Pop al disco
	sw t2, 0(s3)		# Push al disco
	addi t3, t3, 1		# Contador de movimientos
	
	add ra, zero, s5 	# Se suma en ra, que es el valor que se retorna
	jalr ra			# Retorno del valor
	nop

else:
	# Aquí ya empieza la verdadera recursión del problema
	# Primero reservamos 20 bits para la n de los discos, el ra y las 3 torres
	# Cada uno de ellos necesita 4 bits -> 4 * 5 = 20 bits iniciales
	
	addi sp, sp, -20
	sw t2, 0(sp)	# Espacio para el número de discos
	sw ra, 4(sp)	# Espacio para el ra
	sw s1, 8(sp)	# Espacio para la primera torre
	sw s2, 12(sp)	# Espacio para la segunda torre
	sw s3, 16(sp)	# Espacio para la tercer torre
	
	# Mover la posición en base a n
	addi t2, t2, -1		# n - 1 de los discos
	addi s1, s1, -4		# Apuntadores a las posiciones
	addi s2, s2, -4
	addi s3, s3, -4
	
	# hanoi(n - 1, src_rod, to_rod, aux_rod);
	addi s6, s2, 0 		# Se hace el swap de las posiciones como en bubble sort
	addi s2, s3, 0
	addi s3, s6, 0
	
	jal hanoi		# Primera llamada recursiva
	
	# Debemos hacer el pop de la memoria para restaurarla
	lw t2, 0(sp)
	lw ra, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	addi sp, sp, 20
	
	# swapDisk(src_rod, to_rod)
	sw zero, 0(s1) 		# Pop al disco
	sw t2, 0(s3)		# Push al disco
	addi t3, t3, 1		# Contador de movimientos
	
	# Inicio de la segunda recursión
	# Volvemos a hacer la reservación de memoria para la segunda recursión
	addi sp, sp, -20
	sw t2, 0(sp)
	sw ra, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	
	# hanoi(n - 1, aux_rod, src_rod, to_rod);
	addi t2, t2, -1		# n - 1 de los discos
	addi s6, s1, 0 		# Se hace el swap de las posiciones como en bubble sort
	addi s1, s2, 0
	addi s2, s6, 0
	
	addi s1, s1, -4		# Mover los apuntadores con respecto a n
	addi s2, s2, -4
	addi s3, s3, -4
	
	jal hanoi		# Segunda recursión
	
	# Volvemos a hacer el pop de la memoria para volverla a restaurar
	lw t2, 0(sp)
	lw ra, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	addi sp, sp, 20
	
	jalr ra			# Retornamos el valor
	
exit: nop