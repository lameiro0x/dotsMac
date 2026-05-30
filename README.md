# dotsMac

Mis dotfiles de macOS. La mayoría siguen el estándar XDG (`~/.config`), salvo las
excepciones indicadas abajo.

## Terminal: kitty

Terminal actual. La config va en `~/.config/kitty/kitty.conf`:

```sh
mkdir -p ~/.config/kitty
ln -s "$PWD/.config/kitty/kitty.conf" ~/.config/kitty/kitty.conf
```

> Alacritty (`.config/alacritty/`) se mantiene en el repo como respaldo/fallback,
> pero kitty es la terminal en uso.

## Hammerspoon

Vive fuera de `~/.config`, en `~/.hammerspoon/`. El `init.lua` lanza kitty con
`Ctrl + Return`:

```sh
ln -s "$PWD/.hammerspoon/init.lua" ~/.hammerspoon/init.lua
```

## Amethyst

El archivo de Amethyst debe de ir a `~/Library/Preferences/` y se le debe dar permisos con `chmod 600 ~/Library/Preferences/com.amethyst.Amethyst.plist`

Tambien se debe ejecutar `xattr -cr ~/Library/Preferences/com.amethyst.Amethyst.plist` para limpiar atributtos extendidos
