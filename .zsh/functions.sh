function ipt() {
  S=$(/etc/init.d/iptables status | grep -oP "(start|stop)")
  case $S in
    stop)
      echo "shields up! go to red alert!"
      sudo /etc/init.d/iptables start
      ;;
    start)
      echo "lower your shields and surrender your ships!"
      sudo /etc/init.d/iptables stop
      ;;
  esac
}

function nap() {
  mpc --no-status pause
  echo "お休みなさい。。。"
  if [[ $# -ge 1 ]] then 
        TIME=$(( ($(date -d "$*" +%s) - $(date +%s)) / 60 ))
        echo "going down for $TIME minutes..."
        read
        doff
        sleep ${TIME}m
  else 
    doff
    sleep 25m
  fi && {
    echo "b(・ｏ・)dおw(・0・)wはぁで(・＜＞・)まよｃ(^・^)っちゅ"
    wakeup.sh
  }
}

function take_hostage() {
  # encrypts each argument individually, writes names and password in the
  # hostage file for further use
  for i in $(seq $#); do
    pw=$(pwgen -1 -B 16)
    target=$*[$i]
    7z -mx0 -p"$pw" a "$target.7z" "$target"
    7z -p"$pw" t "$target.7z"
    if [ $? -eq 0 ]; then
      cowsay "everything seems alright, killing $target..."
      echo "$target - $pw" >> ~/hostages.txt
      rm -rf "$target"
    fi
  done
}

# bundler
bundler-installed() {
  which bundle > /dev/null 2>&1
}

within-bundled-project() {
  local check_dir=$PWD
  while [ $check_dir != "/" ]; do
    [ -f "$check_dir/Gemfile" ] && return
    check_dir="$(dirname $check_dir)"
  done
  false
}

run-with-bundler() {
  if bundler-installed && within-bundled-project; then
    bundle exec $@
  else
    $@
  fi
}

bundled_commands=(annotate cap capify cucumber ey foreman guard middleman nanoc rackup rainbows rails rake rspec ruby shotgun spec spork thin thor unicorn unicorn_rails)

for cmd in $bundled_commands; do
  eval "function bundled_$cmd () { run-with-bundler $cmd \$@}"
  alias $cmd=bundled_$cmd

  if which _$cmd > /dev/null 2>&1; then
    compdef _$cmd bundled_$cmd=$cmd
  fi
done
