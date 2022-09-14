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
  if test -d $HOME/google-cloud-sdk
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

# terraform 0.13.1
alias terraform13='docker run --rm -it -v $HOME/.config/gcloud:/root/.config/gcloud:ro -v $PWD:/app --workdir /app hashicorp/terraform:0.13.1'

alias terraform112='docker run --rm -it -v $HOME/.config/gcloud:/root/.config/gcloud:ro -v $PWD:/app --workdir /app hashicorp/terraform:1.1.2'

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

export EDITOR=vim
