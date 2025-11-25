#!/bin/bash

# Archivo temporal para guardar el estado anterior
TEMP_FILE="/tmp/sketchybar_net_speed.tmp"

# Interfaz de red activa (ajusta si usas Ethernet o WiFi por otra interfaz)
INTERFACE="en0"

# Obtener bytes de entrada y salida acumulados de la interfaz
read -r IN_NOW OUT_NOW <<< $(netstat -ibn | awk -v iface="$INTERFACE" '
$1 == iface && $0 ~ /^[a-z]/ {
  in_bytes += $7
  out_bytes += $10
}
END {
  print in_bytes, out_bytes
}')

# Tiempo actual
NOW=$(date +%s)

# Si ya tenemos datos guardados, calcular diferencia
if [ -f "$TEMP_FILE" ]; then
  read -r LAST_TIME LAST_IN LAST_OUT < "$TEMP_FILE"

  DELTA_T=$((NOW - LAST_TIME))
  DELTA_IN=$((IN_NOW - LAST_IN))
  DELTA_OUT=$((OUT_NOW - LAST_OUT))

  # Evitar división por cero
  if [ "$DELTA_T" -gt 0 ]; then
    SPEED_DOWN=$(echo "scale=1; $DELTA_IN*8/$DELTA_T/1000000" | bc)
    SPEED_UP=$(echo "scale=1; $DELTA_OUT*8/$DELTA_T/1000000" | bc)

    DOWNLOAD_ICON=""
    UPLOAD_ICON=""

    sketchybar --set $NAME \
      label="$DOWNLOAD_ICON $SPEED_DOWN Mb/s $UPLOAD_ICON $SPEED_UP Mb/s" \
      icon.drawing=off
  fi
fi

# Guardar los valores actuales para la próxima actualización
echo "$NOW $IN_NOW $OUT_NOW" > "$TEMP_FILE"