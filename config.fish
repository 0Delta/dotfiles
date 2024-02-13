function fish_prompt
    eval powerline-go -error $status -shell bare -numeric-exit-codes -shorten-gke-names -shorten-eks-names -condensed -modules-right docker -hostname-only-if-ssh colorize-hostname
end

# prehook function
function async_prompt_prehook
  set ops1 (set_color normal)(echo $argv | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,3})*)?m//g")(set_color normal)
  echo $ops1
end

# ovewrite prompt
function fish_right_prompt -d 'Write out the right prompt'
  set -l pt '⎈ %s'
  if type -q kubectl
    set -l kcc (kubectl config current-context 2>/dev/null)
    if [ "$kcc" = "" ];
      set pt $pt(set_color red)(echo ---)
    else
      set pt $pt(set_color brblue)$kcc
    end
  end
  set pt $pt(set_color white)/
  if type -q gcloud
    set -l gcc (gcloud config get-value project --quiet 2>/dev/null 2>/dev/null)
    if [ "$gcc" = "" ];
      set pt $pt(set_color red)(echo ---)
    else
      set pt $pt(set_color brgreen)$gcc
    end
  end
  set pt $pt(set_color white)
  # printf '⎈ %s' (set_color brblue)(kubectl config current-context 2>/dev/null;or echo ---)(set_color white)
  printf $pt
end

# rbenv
if type -q rbenv
  status --is-interactive; and rbenv init - fish | source
end

# wsl2 timesync
function fish_greeting
  if test -f ~/bin/wsl_timesync.sh
     and test -x ~/bin/wsl_timesync.sh
      ~/bin/wsl_timesync.sh&
  end
end

# gcloud
if type -q gcloud
  source $HOME/google-cloud-sdk/path.fish.inc
  set -x CLOUDSDK_PYTHON_SITEPACKAGES 1
end

alias tree='pwd;find . | sort | sed \'1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/| /g\''

# yubico
if type -q yubico-piv-tool.exe
    alias yubico-piv-tool='yubico-piv-tool.exe'
end

# kubectl
if type -q /home/linuxbrew/.linuxbrew/bin/kubectl
    alias kc='kubectl'
    alias k='kubectl'
end

# memo
alias todo='vim ~/.todo.md'

# golangci-lint
if type -q docker
  alias golangci-lint='docker run --rm -v "$PWD:/app" -w /app golangci/golangci-lint:latest golangci-lint'
end

# gpg
set wsl2_ssh_pageant_bin "$HOME/.ssh/wsl2-ssh-pageant.exe"
set -Ux SSH_AUTH_SOCK "$HOME/.ssh/agent.sock"
# set -Ux SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
if not ss -a | grep -q "$SSH_AUTH_SOCK";
  echo "Startup ssh wsl2_ssh_pageant 1" > /tmp/ssh.log
  rm -f "$SSH_AUTH_SOCK"
  if test -x "$wsl2_ssh_pageant_bin";
    echo "Startup ssh wsl2_ssh_pageant" >> /tmp/ssh.log
    setsid nohup socat -ls -v -s UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --verbose" >> /tmp/ssh.log 2>&1 &
  else
    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
  end
end

# set -Ux GPG_AGENT_SOCK "$HOME/.gnupg/S.gpg-agent"
set -Ux GPG_AGENT_SOCK (gpgconf --list-dirs agent-socket)
set -x WINHOME (wslpath -m ~/WinHome)
# if not ss -a | grep -q "$GPG_AGENT_SOCK";
if not ps aux | grep -v grep | grep -q "$GPG_AGENT_SOCK";
  echo "Startup gpg wsl2_ssh_pageant 1" > /tmp/gpg.log
  rm -rf "$GPG_AGENT_SOCK"
  if test -x "$wsl2_ssh_pageant_bin";
    echo "Startup gpg wsl2_ssh_pageant" >> /tmp/gpg.log
    setsid nohup socat -dd -ls -v -s UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --verbose --gpg S.gpg-agent --gpgConfigBasepath '$WINHOME/AppData/Roaming/gnupg' --logfile /tmp/gpg.log" >> /tmp/gpg.log 2>&1 &
  else
    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
  end
end

# set -x GPG_AGENT_EXTRA_SOCK "$HOME/.gnupg/S.gpg-agent.extra"
set -Ux GPG_AGENT_SOCK (gpgconf --list-dirs agent-extra-socket)
if not ss -a | grep -q "$GPG_AGENT_EXTRA_SOCK";
  echo "Startup gpg wsl2_ssh_pageant 2" > /tmp/gpg_ex.log
  rm -rf "$GPG_AGENT_EXTRA_SOCK"
  if test -x "$wsl2_ssh_pageant_bin";
    echo "Startup gpgex wsl2_ssh_pageant" >> /tmp/gpg_ex.log
    setsid nohup socat -ls -v -s UNIX-LISTEN:"$GPG_AGENT_EXTRA_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --verbose --gpg S.gpg-agent.extra --logfile /tmp/gpg_ex.log" >>/tmp/gpg_ex.log 2>&1 &
  else
    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
  end
end
set --erase wsl2_ssh_pageant_bin

function fish_right_prompt_loading_indicator -a last_prompt
    echo -n "$last_prompt" | sed -r 's/\x1B\[[0-9;]*[JKmsu]//g' | read -zl uncolored_last_prompt
    echo -n (set_color brblack)"$uncolored_last_prompt"(set_color normal)
end

# todoist
if type -q todoist
  alias todoist-cli='todoist'
end
if test -f ~/go/src/github.com/sachaos/todoist/todoist_functions.sh
  source "~/go/src/github.com/sachaos/todoist/todoist_functions.sh"
end
function fish_user_key_bindings
  # fzf
  # fzf_key_bindings

  # todoist
  bind -M insert \eti fzf_todoist_item
  bind -M insert \etp fzf_todoist_project
  bind -M insert \etl fzf_todoist_labels
  bind -M insert \etc fzf_todoist_close
  bind -M insert \etd fzf_todoist_delete
  bind -M insert \eto fzf_todoist_open
  bind -M insert \ett fzf_todoist_date
  bind -M insert \etq fzf_todoist_quick_add
end
fish_user_key_bindings

