if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias ls="lsd"

alias cat="bat"

alias update="brew update && brew upgrade && brew cleanup"

alias poweroff="sudo shutdown -h now"

eval "$(/opt/homebrew/bin/brew shellenv)"

starship init fish | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#if test -f /Users/Fomo/anaconda3/bin/conda
#    eval /Users/Fomo/anaconda3/bin/conda "shell.fish" "hook" $argv | source
#else
#    if test -f "/Users/Fomo/anaconda3/etc/fish/conf.d/conda.fish"
#        . "/Users/Fomo/anaconda3/etc/fish/conf.d/conda.fish"
#    else
#        set -x PATH "/Users/Fomo/anaconda3/bin" $PATH
#    end
#end
# <<< conda initialize <<<

function conda
    functions -e conda
    eval /Users/Fomo/anaconda3/bin/conda "shell.fish" "hook" | source
    command conda $argv
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /Users/Fomo/.ghcup/bin $PATH # ghcup-env