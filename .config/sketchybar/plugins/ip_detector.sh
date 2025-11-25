#!/bin/bash

# Iconos
ICON_PUBLIC="󰲐"
ICON_VPN="󰒄"

# Obtener IP pública
PUBLIC_IP=$(curl -s --max-time 2 https://ipinfo.io/ip)

# Detectar IP VPN tipo HTB (interfaz utun*)
VPN_IP=$(ifconfig utun4 2>/dev/null | grep "inet " | awk '{print $2}')

# Detectar si la VPN cambia IP pública
VPN_PUBLIC_IP=$(curl -s --interface utun4 --max-time 2 https://ipinfo.io/ip)

# Lógica de visualización
if [ -n "$VPN_IP" ]; then
  if [ "$PUBLIC_IP" = "$VPN_PUBLIC_IP" ]; then
    LABEL="$PUBLIC_IP"
    ICON="$ICON_VPN"
  else
    LABEL="$PUBLIC_IP"
    EXTRA_LABEL="$VPN_IP"
    EXTRA_ICON="$ICON_VPN"
    ICON="$ICON_PUBLIC"
  fi
else
  LABEL="$PUBLIC_IP"
  ICON="$ICON_PUBLIC"
fi

# Actualizar IP pública
sketchybar --set vpn_ip label="$LABEL" icon="$ICON"

# Mostrar IP VPN si existe (y si tienes un segundo ítem para ello)
if [ -n "$EXTRA_LABEL" ]; then
  sketchybar --set vpn_extra_ip label="$EXTRA_LABEL" icon="$EXTRA_ICON"
else
  sketchybar --set vpn_extra_ip label="" icon=""
fi
