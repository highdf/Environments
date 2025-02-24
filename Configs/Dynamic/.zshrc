# vim: ft=sh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#################################################
ZSH_THEME="powerlevel10k/powerlevel10k"

# 全局常量
export TOMCAT_WEBAPPS="/usr/share/tomcat9/webapps/"
export ZSH=/usr/share/oh-my-zsh/
export DAY_START=8
export DAY_END=17
export EDITOR='nvim'
export HYPRSHOT_DIR="$HOME/Pictures/Shot/"
export FZF_DEFAULT_OPTS="--layout=reverse --height 60% --border --prompt='🔍 '"
export DEEPSEEK_API_KEY="sk-0f22610a8809467e9e0d12d4bd938c34"
export NAMESRV_ADDR='localhost:9876'
export WECHAT_DATA_DIR='Misc/WeChat_Data'

# export MY_LIBC="${HOME}/Code/mylibc"
# export LD_LIBRARY_PATH="${MY_LIBC}/libs:${LD_LIBRARY_PATH}"
# export C_INCLUDE_PATH="${MY_LIBC}/headers:${C_INCLUDE_PATH}"
# export LIBRARY_PATH="${MY_LIBC}/libs:${LIBRARY_PATH}"
# export LDLIBS="-lstring -lerror"

# 脚本路径配置
export DAILY_SCRIPT="$HOME/Environments/Scripts"
export PATH=$DAILY_SCRIPT/work_flow:$PATH
export PATH=$DAILY_SCRIPT/Environments_init:$PATH
export PATH=$DAILY_SCRIPT/Daily_auto:$PATH
export HYPR_SCRIPT="$HOME/.config/hypr"
export PATH=$HYPR_SCRIPT/Scripts:$PATH
export MAVEN_OPTS="--enable-native-access=ALL-UNNAMED"

# export PRETTIERD_DEFAULT_CONFIG="/home/luky/.config/nvim/lua/coding/format/config/.prettierrc.json"

# bashrc配置文件路径
alias sbash='source ~/.bashrc'
alias szsh='source ~/.zshrc'
alias vim='nvim'
alias sp="systemctl poweroff"
alias sr="systemctl reboot"
alias us='uwsm stop'
alias mycc="gcc ${LDLIBS}"
alias stylefix="stylelint --fix -c ${HOME}/.config/nvim/lua/coding/lint/project_config/stylelintrc.json "

# clash路径
function clash_toggle() {
  if [ -z "$(pgrep -x clash)" ]; then
    nohup /usr/bin/clash >/dev/null 2>&1 &
    echo "Clash On"
  else
    pgrep clash | xargs kill
    echo "Clash Off"
  fi
}

function mvn_create() {
  local project_type="maven-archetype-quickstart"
  local package_name="com.luky"
  # local template="$HOME/Environments/Configs/Static/Template/maven"
  local target_dir=$(echo "${package_name}" | awk -F '.' '{printf "%s/%s", $1, $2}')

  if [[ $# -eq 2 ]]; then
    case "$2" in
    "web")
      project_type="maven-archetype-webapp"
      ;;
    "sprint")
      project_type="spring-boot-starter-web"
      ;;
    esac
  elif [[ $# -gt 2 ]]; then
    echo "Please usage mvn project_name or mvn project_name [web/spring]"
    return 1
  fi

  mvn archetype:generate -DgroupId=${package_name} -DartifactId=$1 \
    -DarchetypeArtifactId="${project_type}" -DinteractiveMode=false

  if [[ ${2} == "web" ]]; then
    mkdir -p "$1/src/main/java/${target_dir}"
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

# default enabled
export http_proxy='http://127.0.0.1:7897'
export https_proxy='http://127.0.0.1:7897'
export HTTP_PROXY='http://127.0.0.1:7897'
export HTTPS_PROXY='http://127.0.0.1:7897'

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
function arch_clean() {
  sudo pacman --sync --clean --noconfirm
  yay --sync --clean --noconfirm
}

function uwsm_start() {
  uwsm check may-start
  uwsm select
  uwsm start default &>/dev/null
}

function clash_update() {
  clash_toggle
  proxy_toggle
  local clash_home="${HOME}/.config/clash/config.yaml"

  if [[ -f ${clash_home} ]]; then
    rm -rf ${clash_home}
    echo "${clash_home} removed"
  else
    echo "${clash_home} not exists"
  fi

  curl 'https://node.freeclash.net/uploads/2026/05/0-20260531.yaml' -o "${clash_home}" \
    >/dev/null 2>&1

  proxy_toggle
  clash_toggle
  echo "clash config updated"
}

if uwsm check may-start &>/dev/null; then
  if [[ ! -e "${HOME}/.config/uwsm/default-id" ]]; then
    uwsm select && {
      theme_switch.py
      uwsm start default
    }
  else
    theme_switch.py
    uwsm start default
  fi
fi

# end
#################################################

# plugins=(zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pnpm
export PNPM_HOME="/home/luky/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
