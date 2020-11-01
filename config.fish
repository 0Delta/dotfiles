function fish_prompt
    eval powerline-go -error $status -shell bare -colorize-hostname -condensed -modules-right docker,kube -shorten-gke-names -shorten-eks-names
end
