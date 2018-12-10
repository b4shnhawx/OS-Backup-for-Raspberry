# OS-Backup-for-Raspbery
### Description
This script help you to know in which disk you can make a backup of your Raspbian OS.

### My problem
I usually use Piclone to back up my Raspbian operating system. When we run this program, the source disk is clear (/dev/mmcblk0), but the target disk is not so when you have two other disks connected to your Raspberry.

<p align="center">
  <img width="437" height="174" src="https://github.com/davidahid/OS-Backup-for-Raspbery/blob/master/images/problem.png">
</p>

To make sure, I had to run lsblk to see what name had my destination disk. Obviusly, it's not a difficult task, but where is the fun if we can automate this task??

### Configuration
We need to know first the disk size and UUID of our destination disk. To know it just we need to disconnect all of our disks, less the destination disk, and type the next commands:
```js
cat /tmp/lsblk_tmp_file | grep disk | tr -s " " | cut -f4 -d" " | tr " " "\t"
```
```js
blkid | cut -d " " -f3 | grep UUID
```

When we have this two data, we just copy it in the configuration lines of the script.
```js
#---------------------------------------------------- Configuration ----------------------------------------------------

#Creamos una variable en la que especificamos el tamanio del disco donde queremos hacer la copia de seguridad.
#Colocamos el tamanio ya que es la forma mas facil de identificar dos discos con el lsblk, ya que el resto de 
#valores puede cambiar.
#IMPORTANTE
#Si tenemos mas de un disco del mismo tamanio deberemos tener cuidado y corroborar que es correcto.
backup_size="14.9G"

#Tambien deberemos insertar el UUID del disco (este ID es unico en cada disco). De esta manera podemos diferenciar 
#entre dos discos de tamanios iguales. Aunque el script funcionaria solo con este ID, es mejor dejar dos valores por asegurar...
backup_uuid="25765c7c-5d3f-488a-85bc-bcb66bfa7c78"
```

### Example
Finally when we execute the script, the following will appear.
<p align="center">
  <img width="1090" height="330" src="https://github.com/davidahid/OS-Backup-for-Raspbery/blob/master/images/example.png">
</p>
