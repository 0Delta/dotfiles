function fish_prompt
    eval powerline-go -error $status -shell bare -numeric-exit-codes -shorten-gke-names -shorten-eks-names -condensed -modules-right docker,kube -hostname-only-if-ssh colorize-hostname
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

