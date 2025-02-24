# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#################################################
ZSH_THEME="powerlevel10k/powerlevel10k"

# 全局常量
export DAY_START=7
export DAY_END=17
export EDITOR='nvim'
export HYPRSHOT_DIR="$HOME/Pictures/Shot/"
export FZF_DEFAULT_OPTS="--layout=reverse --height 60% --border --prompt='🔍'"

# 脚本路径配置
export DAILY_SCRIPT="$HOME/Environments/Scripts"
export PATH=$DAILY_SCRIPT/Environments_init:$PATH
export PATH=$DAILY_SCRIPT/Daily_auto:$PATH
export HYPR_SCRIPT="$HOME/.config/hypr"
export PATH=$HYPR_SCRIPT/Scripts:$PATH

# bashrc配置文件路径
alias vimb='vim ~/.bashrc'
alias sbash='source ~/.bashrc'
alias szsh='source ~/.zshrc'
alias vim='nvim'
alias sp="systemctl poweroff"
alias sr="systemctl reboot"

# clash路径
function clash_toggle() {
    if [ -z "$(pgrep -x clash)" ]; then
		nohup /usr/bin/clash > /dev/null 2>&1 &
		echo "Clash On"
    else
		pgrep clash | xargs kill
		echo "Clash Off"
    fi
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# 默认开启
export http_proxy='http://127.0.0.1:7890'
export https_proxy='http://127.0.0.1:7890'
export HTTP_PROXY='http://127.0.0.1:7890'
export HTTPS_PROXY='http://127.0.0.1:7890'

# # 关闭/开启代理
function proxy_toggle() {
    local proxy_url="http://127.0.0.1:7890"
    
    if [[ -z "${http_proxy}${https_proxy}${HTTP_PROXY}${HTTPS_PROXY}" ]]; then
        export http_proxy="$proxy_url"
        export https_proxy="$proxy_url"
		export HTTP_PROXY="$proxy_url"
		export HTTPS_PROXY="$proxy_url"
        echo "Proxy ON: $proxy_url"
    else
        unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
        echo "Proxy OFF"
    fi
}

# vim跳转
function vimj() {
    if [ -z "$1" ]; then
        echo "Usage: vimj [k|c|l|z|t|h]" >&2
        return 1
    fi
    case "$1" in
        "k") vim ~/.config/kitty/kitty.conf ;;
        "c") vim ~/.config/nvim ;;
        "l") vim ~/.local/share/nvim/lazy/ ;;
        "z") vim ~/.zshrc ;;
        "t") vim ~/.tmux.conf ;;
        "h") vim ~/.config/hypr/ ;;
        *) echo "Invalid option: $1. Use 'k', 'c','t', 'h', or 'l'." >&2 ;;
    esac
}

# archlinux
function arch_key() {
	sudo pacman -Sy archlinux-keyring
	sudo pacman-key --refresh-keys
	sudo pacman-key --pipulate archlinux
}
function arch_upgrade() {
	sudo pacman --sync --sysupgrade --refresh --noconfirm
}

function uwsm_start() {
	uwsm check may-start
	uwsm select
    uwsm start default &> /dev/null
}

if uwsm check may-start &> /dev/null && uwsm select; then
	theme_switch.py
	uwsm start default
fi
# end
#################################################

# End of lines added by compinstall
# Path to your Oh My Zsh installation.
# export ZSH="$HOME/.oh-my-zsh"
export ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# Example of the original line in ~/.zshrc

# plugins=(zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
