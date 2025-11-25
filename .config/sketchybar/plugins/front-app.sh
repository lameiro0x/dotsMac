#!/bin/bash

ICON_COLOR=0xffff7f17

case "$INFO" in
  "Arc")
    ICON_PADDING_RIGHT=5
    ICON=󰞍
    ;;
  "Code")
    ICON_PADDING_RIGHT=2
    ICON_COLOR=0xff22a1f0
    ICON=󰨞
    ;;
  "Calendar")
    ICON=
    ;;
  "Discord")
    ICON_COLOR=0xff5b5bf5
    ICON=󰙯
    ;;
  "FaceTime")
    ICON=
    ;;
  "Finder")
    ICON_COLOR=0xff40b9ff
    ICON=󰀶
    ;;
  "Firefox")
    ICON=󰈹
    ;;
  "Google Chrome")
    ICON=
    ;;
  "IINA")
    ICON=󰕼
    ;;
  "kitty" | "Alacritty" | "Terminal")
    ICON=
    ICON_COLOR=0xff89b4fa
    ;;
  "nvim" | "Neovide" | "Neovim")
    ICON=
    ICON_COLOR=0xffa6e3a1
    ;;
  "Obsidian")
    ICON=󰎞
    ICON_COLOR=0xffbd93f9
    ;;
  "Messages")
    ICON=󰍦
    ;;
  "Notion")
    ICON_COLOR=0xff000000
    ICON=󰈄
    ;;
  "Preview")
    ICON_COLOR=0xff137DF8
    ICON=
    ;;
  "PS Remote Play")
    ICON=
    ;;
  "Spotify")
    ICON_COLOR=0xff24D44E
    ICON=
    ;;
  "TextEdit")
    ICON=
    ;;
  "Transmission")
    ICON=󰶘
    ;;
  "Unknown" | "")
    INFO="Unknown"
    ICON_COLOR=0xffffffff
    ICON=﯂
    ;;
  "ChatGPT")
    ICON=󰚩
    ICON_COLOR=0xffffffff
    ;;
esac

sketchybar --set "$NAME" \
  icon="$ICON" icon.color="$ICON_COLOR" \
  label="$INFO"