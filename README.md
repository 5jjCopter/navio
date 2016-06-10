# navio
Contenido:
ardupilol (scripts para arranque apm)...Cambiar ip y veiculo para nuestra nesesidad.
video (scripts para arranque de video)...Cambiar resolocion,fps y ip para nuestra nesecidad.
temp.py (scripts que mide temperatura de cpu de raspberry y guarda en home/pi/temp.txt con fecha +hora.
xxxx.service (scripts de servicio para arranque en incio).
actualizacion (scripts para actualizar apm en navio + tambien incluido en el archivo del repositorio de instalacion automatica)
actualizacion2(scripts para actualizar apm en navio 2 tambien incluido en el archivo del repositorio de instalacion automatica)

Designada en interfaces ip fija para wifi,comfigurar si quieren otro tipo de ip.
Cambiar en (sudo nano /etc/network/interfaces)
Configuracion actual.
auto lo

iface lo inet loopback

iface eth0 inet dhcp

auto wlan0
iface wlan0 inet static
address 192.168.1.122
netmask 255.255.255.0
gateway 192.168.1.1
wpa-ssid "xxxxx"
wpa-psk "xxxxxxxxxxxxx"

Cambiar (x) en ssid por nombre de ruter o punto de acseso y en wpa-psk por comtraseña de ruter o punto de acseso.
