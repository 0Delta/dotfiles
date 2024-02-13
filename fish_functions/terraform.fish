# terraform version auto detector
# run terraform with container
function terraform
  if test ! -e /var/log/terraform_docker
    echo "logdir not exists. creating ..."
    sudo mkdir /var/log/terraform_docker
    sudo chown $USER:$USER /var/log/terraform_docker
    sudo chmod a+rw /var/log/terraform_docker
  end
  set -f wkdir (string match -r -i -- '-chdir=(.*)' $argv)[2]
  set -f pwd (pwd)
  if test -n "$wkdir"
    echo "detect subdir : $wkdir"
    cd $wkdir
  end
  set -f tff (find . -maxdepth 1 -name "*.tf" | wc -l)
  if test $tff -gt 0
    set -f tfv (grep -ohPz 'terraform(\s*){(.*\n)*(\s*)required_version(\s*)>?=(\s*)"[~>= ]*?([0-9.]+)"' *.tf | grep -aoP 'required_version.*' | sed -z "s/[a-z:{>=_\" \n]//g")
    cd $pwd
    if test -n "$tfv"
      if string match -r --quiet -- '~.*' $tfv
        set -f tfv (echo $tfv | sed -z "s/[~]//g")
        set -f tfv (get_terraform_version $tfv)
      end
      echo detect terraform : v$tfv
      nerdctl run --rm -it -v /var/log/terraform_docker:/var/log/tf -v $HOME/.config/gcloud:/root/.config/gcloud:ro -v /dev/random:/dev/random:ro -v $PWD:/app --workdir /app -e "TF_LOG_PATH=/var/log/tf/terraform_trace.log" -e "TF_LOG=$TF_LOG" hashicorp/terraform:$tfv $argv
    else
      echo "terraform version not detected"
      echo "please check terraform file include { required_version = \"x.x.x\" }"
    end
  else
      echo "terraform version not detected"
      echo "current directory is not terraform directory"
  end
  cd $pwd
end

function get_terraform_version
  set -l ftime (stat --printf '%Y' /tmp/terraform_versions.list)
  set -l ntime (date +%s)

  if test (math $ftime - 60 x 60 x 24 x 7) -gt $ntime
    echo "fetch terraform versions"
    curl -s "https://registry.hub.docker.com/v2/namespaces/hashicorp/repositories/terraform/tags?page_size=100&page=1" | sed "s/,/\n/g" | grep '"name"' | grep -v "-" | cut -d '"' -f 4 > /tmp/terraform_versions.list
    curl -s "https://registry.hub.docker.com/v2/namespaces/hashicorp/repositories/terraform/tags?page_size=100&page=2" | sed "s/,/\n/g" | grep '"name"' | grep -v "-" | cut -d '"' -f 4 >> /tmp/terraform_versions.list
    curl -s "https://registry.hub.docker.com/v2/namespaces/hashicorp/repositories/terraform/tags?page_size=100&page=3" | sed "s/,/\n/g" | grep '"name"' | grep -v "-" | cut -d '"' -f 4 >> /tmp/terraform_versions.list
    sort -g /tmp/terraform_versions.list -o /tmp/terraform_versions.list
  end
  grep "^$argv" /tmp/terraform_versions.list | tail -n 1
end

