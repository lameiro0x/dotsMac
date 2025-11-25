#!/bin/bash

sketchybar --set $NAME \
  label="Loading..." \
  icon.color=0xff5edaff

# Configuración para Madrid, España
LOCATION="Madrid"
REGION="Community of Madrid"
COUNTRY="ES"

# Reemplazar espacios con "+" para la URL
LOCATION_ESCAPED="${LOCATION// /+}+${REGION// /+}"
WEATHER_JSON=$(curl -s "https://wttr.in/$LOCATION_ESCAPED?format=j1")

# Verificar si la respuesta está vacía o no es JSON válido
if [ -z "$WEATHER_JSON" ]; then
  sketchybar --set $NAME label="Unknown"
  return
fi

if ! echo "$WEATHER_JSON" | jq empty 2>/dev/null; then
  sketchybar --set $NAME label="Invalid data"
  return
fi

# Obtener temperatura y descripción del clima
TEMPERATURE=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].temp_C')
WEATHER_DESCRIPTION=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].weatherDesc[0].value' | sed 's/\(.\{16\}\).*/\1.../')

# Actualizar el ítem en SketchyBar
sketchybar --set $NAME \
  label="${TEMPERATURE}°C • $WEATHER_DESCRIPTION"
