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
