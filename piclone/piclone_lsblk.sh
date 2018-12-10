#!/bin/bash

#IMPORTANTE
#Este script es muy concreto. Un ligero cambio en el sistema (cambiar el tamano de la SD de backup por ejemplo), podria variar el
#comportamiento de este script ya que se fijan algunas unidades de almacenamiento. Tambien la salida puede quedar descolocada en
#algunos casos, pero por ahora esta ok.
#Esta por ver como se comporta al anadir nuevas unidades USB, remover otras, etc, pero a priori con esto no deberia presentar probelma.
#Seguiremos informando.

#-------------------------------------------------------------- Configuration --------------------------------------------------------------

#Creamos una variable en la que especificamos el tamanio del disco donde queremos hacer la copia de seguridad.
#Colocamos el tamanio ya que es la forma mas facil de identificar dos discos con el lsblk, ya que el resto de valores puede cambiar.
#IMPORTANTE
#Si tenemos mas de un disco del mismo tamanio deberemos tener cuidado y corroborar que es correcto.
backup_size="14.9G"

#Tambien deberemos insertar el UUID del disco (este ID es unico en cada disco). De esta manera podemos diferenciar entre dos discos de tamanios
#iguales. Aunque el script funcionaria solo con este ID, es mejor dejar dos valores por asegurar...
backup_uuid="25765c7c-5d3f-488a-85bc-bcb66bfa7c78"

#------------------------------------------------------------- Script -------------------------------------------------------------

#Buscamos el ID del disco y lo guardamos en la variable blkid_backup_uuid. De esta manera si no encontrase el ID (disco no coenctado), la variable
#estaria vacia.
blkid_backup_uuid=`sudo blkid | grep -o $backup_uuid | uniq`

#Guardamos la salida de lsblk en la ruta temporal de la raspberry (/temp)
lsblk > /tmp/lsblk_tmp_file

#Contamos y guardamos el numero de lineas que hay en el lsblk del archivo creado en /temp
linesnumber=`sudo cat /tmp/lsblk_tmp_file | grep disk | wc -l`

#Creamos un bucle que se repite tantas veces como lineas tenga el lsblk
for line in $(seq 1 $linesnumber);
do
	#Guardamos el nombre del ultimo disco encontrado
	namedisk=`sudo cat /tmp/lsblk_tmp_file | grep disk | head -n $line | tail -n 1 | tr -s " " | cut -f1 -d" " | tr " " "\t"`
	#Guardamos el tamaño del ultimo disco encontrado
	sizedisk=`sudo cat /tmp/lsblk_tmp_file | grep disk | head -n $line | tail -n 1 | tr -s " " | cut -f4 -d" " | tr " " "\t"`
	#Guardamos el tipo del ultimo disco encontrado
	typedisk=`sudo cat /tmp/lsblk_tmp_file | grep disk | head -n $line | tail -n 1 | tr -s " " | cut -f6 -d" " | tr " " "\t"`
	#Guardamos el punto de montaje del ultimo disco encontrado
	mountdisk=`sudo cat /tmp/lsblk_tmp_file | grep part | head -n $line | tail -n 1 | tr -s " " | cut -f7-8 -d" " | tr " " "\t"`

	#Si el nombre del disco es igual a sd* (sda, sdb, sdc, etc), y el tamano es igual a 14.9G (SD de backup que estoy usando)...
	if [[ $namedisk == sd* && $backup_uuid = $blkid_backup_uuid && $sizedisk = $backup_size ]];
	then
		#...imprime en pantalla el nombre (subrayado en verde [42m y con letra blanca [30m), tamanio, tipo y punto de anclaje dee
		#la SD de backup. Aqui es donde se debe hacer el backup.
		echo -e  "\e[42m\e[30m"$namedisk"\e[0m\e[0m" "\t" $sizedisk "\t\t" $typedisk "\t" $mountdisk

	#...si el nombre del disco es igual a sd* (sda, sdb, sdc, etc), y el tamano es igual a 931.5G (NAS)...
	elif [[ $namedisk == sd* ]];
	then
		#...imprime en pantalla el nombre (subrayado en rojo [41m y con letra blanca [30m), tamaño, tipo y punto de anclaje del
		#NAS. AQUI NO SE DEBE HACER LA COPIA.
		echo -e "\e[41m\e[30m"$namedisk"\e[0m\e[0m" "\t" $sizedisk "\t" $typedisk "\t" "\e[41m\e[30m"$mountdisk"\e[0m\e[0m"

	#...si el nombre del disco es igual a mmcblk0, es decir donde se encuentra el OS (lo pongo a parte ya que no se epuede tabular entre
	#$namedisk y $sizedisk ya que el nombre es muy largo y desordena la salida, por lo que hay que tratarlo diferente y poner nada mas
	#que un espacio, pero no lo pongo ahi por otra cosa)...
	elif [[ $namedisk = "mmcblk0" || $blkid_backup_uuid != $backup_uuid || $blkid_dont_touch_uuid != $dont_touch_uuid ]];
	then
		#...imprime en pantalla el nombre, tamaño, tipo y punto de anclaje de los archivos del OS. AQUI NO SE DEBE HACER LA COPIA
		#aunque de todas formas no deja hacerla xd
		echo -e $namedisk "" $sizedisk "\t\t" $typedisk "\t" $mountdisk

	#...y si no coincide con ninugno de los anteriores, es decir, que son unidades de almacenamtiento nuevas...
	else
		#...imprime en pantalla el nombre, tamaño, tipo y punto de anclaje de los archivos de la unidad.
		echo -e $namedisk "\t" $sizedisk "\t" $typedisk "\t" $mountdisk

	fi
#Termina el bucle y pasamos al siguiente disco que haya en el lsblk. Si no hay mas el script termina.
done

#Pruebas
#sudo cat /tmp/lsblk_tmp_file | grep disk | tr -s " " | cut -f1,4,6,8 -d" " | tr " " '\t''\t'
#sudo cat /tmp/lsblk_tmp_file | tr "├─" " " | tr -s " " | cut -f1,2,5-8 -d" " | tr " " "     "
