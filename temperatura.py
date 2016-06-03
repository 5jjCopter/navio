#ESTE SCRIPTS PYTHOM HA SIDO CREADO POR JUAN JOSE CASTO MORENO
#ES LIBRE DE MODIFICAR LO QUE QUIERA PERO NO SE OLVIDE NUNCA DE COMPARTIR PARA QUE OTROS PUEDAN APRENDER
#ESTE SCRIPTS LEE LA TEMPERATURA DE LA CPU Y CREA UN TXT GUARDANDOLAS POR FECHA Y HORA.
import commands #IMPORTAMOS COMMANDS
import time #IMPORTAMOS TIME

def get_cpu_temp(): #DEFINIMOS get_cpu_temp
    tempFile = open( "/sys/class/thermal/thermal_zone0/temp" ) # tempFile ES IGUAL A HABRIR (DIRECCCION DEL SENSOR DE TEMPERATURA DE CPU)
    cpu_temp = tempFile.read() #cpu_temp ES IGUAL A LEER tempFile
    tempFile.close()#CERRAMOS
    return float(cpu_temp)/1000 #CONVERTIMOS EN FLOTANTE Y DIVIDIMOS POR 1000

data = open("temp.txt", "w") #DEFINIMOS QUE DATA ES IGUAL A HABRIR TXT LLAMADO (temp.txt) CON PERMISO DE ESCRITURA
data.write("%s,%s\n" % (get_cpu_temp(),time.strftime("%b %d %Y %H:%M:%S"))) #ESCRIBE LA TEMPERATURA MAS LA FECHA CON SALTO DE LINEA
data.close() #CERRAMOS
time.sleep(5) # ESPERA 5 SEGUNDOS(AQUI PODEMOS CAMBIAR EL INTERVALO EN EL QUE TOMA LA TEMPERATURA
for i in range(200): # CAMTIDAD DE VECES QUE VA A ESCRIVIR LA LECTURA DE TEMPERATURA

    data = open("temp.txt", "a")
    data.write("%s,%s\n" % (get_cpu_temp(),time.strftime("%b %d %Y %H:%M:%S")))
    data.close()    
    time.sleep(5)#Pausa de 5 segundos entre comprobaciones
