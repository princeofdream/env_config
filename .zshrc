# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/vjames/.zshrc'

autoload -Uz compinit
compinit

powerline-daemon -q
. $HOME/.vim/bundle/powerline/powerline/bindings/zsh/powerline.zsh

# End of lines added by compinstall
