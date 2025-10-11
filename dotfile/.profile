case "$SHELL" in
  */zsh)
    if command -v fzf >/dev/null 2>&1 && command -v fd >/dev/null 2>&1; then

      export FZF_DEFAULT_OPTS=" \
        --color fg:#ffffff,bg:#222222,hl:#98c379,fg+:#ffffff,bg+:#222222,hl+:#98c379,prompt:#222222,pointer:#e5c07b,marker:#56b6c2 \
        --ansi --reverse --no-info --no-scrollbar \
        --pointer=' '"

      # =========[ File Insert Widget: Alt+T ]=========
      fzf-file-widget() {
        local result
        result=$(fd -H -t f -E .git | \
          fzf --prompt="Select file ➤ " --exit-0 \
              --height=40% --border --reverse \
              --ansi --no-info --no-scrollbar \
        )
        local ret=$?

        if (( ret == 0 )) && [[ -n "$result" ]]; then
          LBUFFER+="$result"
        fi

        zle reset-prompt
      }
      zle -N fzf-file-widget
      bindkey '^[t' fzf-file-widget

      # =========[ Directory CD Widget: Alt+C ]=========
      fzf-cd-widget() {
        local dir
        dir=$(fd -H -t d -E .git | \
          fzf --prompt="Select directory ➤ " --exit-0 \
              --height=40% --border --reverse \
              --ansi --no-info --no-scrollbar \
        )
        local rc=$?

        if (( rc == 0 )) && [[ -n "$dir" ]]; then
          cd "$dir" || return
        fi

        zle reset-prompt
      }
      zle -N fzf-cd-widget
      bindkey '^[c' fzf-cd-widget

      # =========[ History Search Widget: Ctrl+R ]=========
      fzf-history-widget() {
        local selected
        selected=$(fc -l 1 | \
          fzf --tac --no-sort --reverse \
              --prompt="History ➤ " --exit-0 \
              --height=40% --border \
              --ansi --no-info --no-scrollbar \
          | sed -E 's/^[[:space:]]*[0-9]+\s*//')

        local rc=$?

        if (( rc == 0 )) && [[ -n "$selected" ]]; then
          LBUFFER="$selected"
        fi

        zle reset-prompt
      }
      zle -N fzf-history-widget
      bindkey '^R' fzf-history-widget

    fi
    ;;
esac
# =========[ fzf Completion Setup ]=========

if command -v fzf >/dev/null 2>&1; then
  case "$SHELL" in
    */zsh)
      # Ensure completion system is initialized
      fpath+=~/.zfunc
      autoload -Uz compinit
      compinit

      # Install/update fzf zsh completion if missing
      if [ ! -f ~/.zfunc/_fzf ]; then
        mkdir -p ~/.zfunc
        fzf --zsh > ~/.zfunc/_fzf
      fi
      ;;

    # */bash)
    #   # Load global bash-completion if available
    #   if [ -f $PREFIX/share/fzf/completion.bash ]; then
    #     . $PREFIX/share/fzf/completion.bash
    #   fi
    #
    #   # Load fzf bash completion (inline)
    #   source <(fzf --bash)
    #   ;;
  esac
fi
# =========[ Custom T-header(logo with figlet) Setup ]=========

if command -v figlet >/dev/null 2>&1 && \
   command -v tput >/dev/null 2>&1; then

  user="$(mktemp)"
  banner () {
    clear
    tput civis
    # === Load config === #
    CONFIG="$HOME/.config/theader/theader.cfg"
    LOGO_DIR="$HOME/.config/theader/logo"

    # === Load title from config (fallback: "tyro 2.0") === #
    title=$(grep '^title=' "$CONFIG" | cut -d'=' -f2-)
    [[ -z "$title" ]] && title="tyro 2.0"

    # Support dynamic tokens in title from config
    case "$title" in
      TIME|time|{TIME}|{time}|%TIME%|%time%)
        title="$(date '+%H:%M')"
        ;;
      DATETIME|datetime|{DATETIME}|{datetime}|%DATETIME%|%datetime%)
        title="$(date '+%Y-%m-%d %H:%M')"
        ;;
    esac

    # Print logo at top inside the box
    if [[ -n "$logo_file" && -f "$LOGO_DIR/$logo_file" ]]; then
      tput cup 1 1
      sed "s/^/${indent}/" "$LOGO_DIR/$logo_file"
    fi

    # Print title (figlet) below logo, optionally with lolcat
    tput cup $((1 + logo_h + v_gap)) 1
    if command -v lolcat >/dev/null 2>&1; then
      sed "s/^/${indent}/" "$fig_tmp" | lolcat -f
    else
      echo -en "\033[97m"
      sed "s/^/${indent}/" "$fig_tmp"
      echo -en "\033[0m"
    fi

    # Cleanup and restore cursor
    rm -f "$fig_tmp"
    tput cup $((inner_h + 2)) 0
    tput cnorm
  }

  # banner >> "${user}"
  # cat "${user}"
fi
# Load aliases if file exists
[ -f ~/.aliases ] && source ~/.aliases

export EDITOR='nvim'
# export RUSTC=$PREFIX/opt/rust-nightly/bin/rustc

# export ANDROID SDK $HOME/Android/android-sdk

# export ANDROID_NDK=$HOME/android-ndk-r27b

# export ANDROID_NDK_LATEST_HOME=$HOME/android-ndk-r27b/

# export GYP_DEFINES=\"android_ndk_path=\'ANDROID_NDK\'\"

# export RUST_TARGET=aarch64-linux-android

#include libs
# export LIBXML_CFLAGS="-I/data/data/com.termux/files/usr/include/libxml2"
# export LIBXML_LIBS="-L/data/data/com.termux/files/usr/lib -lxml2"
#
# export SQLITE_CFLAGS="-I/data/data/com.termux/files/usr/include"
# export SQLITE_LIBS="-L/data/data/com.termux/files/usr/lib -lsqlite3"


# pyenv exports

# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"
# export DOCKER_HOST="tcp://localhost:2375"
