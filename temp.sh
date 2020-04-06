/bin/bash
 # Shell script: temp.sh
  # Autor: Santiago Crespo - Modificado por Marcos Matas
  echo "Equipo => $(hostname)"
  echo "$(date)"
  echo "------------------------------"
  echo "Temp.CPU => $(/opt/vc/bin/vcgencmd measure_temp)"
  echo "Temp.GPU => $(/opt/vc/bin/vcgencmd measure_temp)"
  echo "------------------------------"
  echo "CPU"
  echo "$(vcgencmd measure_clock arm)Hz"
  echo "$(vcgencmd measure_volts core)"
  echo "Mem. del Sistema $(vcgencmd get_mem arm)"
  echo "Mem. de la $(vcgencmd get_mem gpu)"
  echo "------------------------------"
  echo "Consumo de memoria"
  echo "$(egrep --color 'Mem|Cache|Swap' /proc/meminfo)"
