#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# Shows some nice status bar. The left side reads input from a pipe


# processes with >= 50% cpu load
cpu_hogs() {
    ps -eo pcpu,ucmd --sort -pcpu | tail -n +2 | while read proc
    do
        if [[ $proc[(w)1] -ge 50.0 ]] then
            echo $proc[(w)1] ${${proc[(w)2]}[1,10]}
        fi
    done
                           
}

hostname=$(hostname)

status() {
    statusbar=()

    # current load
    st_uptime="L: $(uptime | sed -e 's/.*://; s/,//g')"

    # memory usage
    mem=(${$(free -m | grep "Mem:")[2,7]})
    st_mem=$(printf "M: %4d(%+5d)/%4d" $(($mem[2] - $mem[5] - $mem[6])) $mem[6] $mem[1])

    # processes with >= 50% cpu load
    st_ps="P: $(cpu_hogs)"

    # current date
    year=$(($(date "+%y") + 12))
    st_date="D: $(date "+%A, 平成${year}年%m月%d日 %H時%M分%S秒")"

    # rest time of current cycle
    #st_cycle=$(cycle)

    # days until apocalypse
    st_apoc="A: $(( ($(date --date "2012-12-21" "+%s") - $(date "+%s")) / 86400))日" 

    # volume
    mixer="vmix0-outvol"
    st_volume="V: $(ossmix $mixer | sed -e "s/.*set to \([0-9.]\+\).*/\1/")"

    # expanding widgets are always left
    statusbar+=("$st_ps")

    # laptop specific
    if [[ $hostname == "nyarlathotep" ]] then
        # wifi strength
        st_wifi="W: $(cat /sys/class/net/wlan0/wireless/link)%"
        
        # battery status
        st_battery="B: ${$(acpi)[(w)3,-1]}"

        statusbar+=("$st_wifi" "$st_battery")
    fi
    statusbar+=("$st_uptime" "$st_mem" "$st_volume" "$st_date" "$st_apoc")
    echo ${(j: | :)statusbar}
}
    
while sleep 0.9s
do 
    status
done
