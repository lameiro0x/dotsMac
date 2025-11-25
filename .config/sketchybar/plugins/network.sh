#!/bin/bash

# Ícono de red (puedes cambiarlo si prefieres uno de WiFi)
ICON="󰲐"

# Obtener la IP pública desde un servicio web
IP=$(curl -s https://ipinfo.io/ip)

# Si no se pudo obtener, mostrar mensaje de error
if [ -z "$IP" ]; then
  IP="Sin conexión"
  ICON=""
fi

# Actualizar el módulo en SketchyBar
sketchybar --set $NAME \
  label="$IP" \
  icon="$ICON"
