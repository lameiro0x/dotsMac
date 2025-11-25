#!/bin/bash

# Obtener número total de espacios (Yabai incluye uno extra)
NUM_SPACES=$(yabai -m query --spaces | jq 'length')
CURRENT_SPACE=$(yabai -m query --spaces --space | jq -r '.index')

# Restar uno al total (por el espacio fantasma que añade macOS)
NUM_SPACES=$((NUM_SPACES - 1))

# Evitar números negativos
if [ "$NUM_SPACES" -lt 1 ]; then
  NUM_SPACES=1
fi

# Si algo falla, valores por defecto
if [ -z "$CURRENT_SPACE" ] || [ "$CURRENT_SPACE" -lt 1 ]; then
  CURRENT_SPACE=1
fi

# Construir los puntos
LABEL=""
for i in $(seq 1 "$NUM_SPACES"); do
  if [ "$i" -eq "$CURRENT_SPACE" ]; then
    LABEL+="● "
  else
    LABEL+="○ "
  fi
done

# Actualizar el item en SketchyBar
sketchybar --set spaces label="$LABEL"
