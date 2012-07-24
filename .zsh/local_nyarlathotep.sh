alias un='unison kira'
alias ur='unison kira-repo'
alias uep='sudo unison kira-portage -times -log=false -auto -ui=text'
alias uo='unison kira-ongaku'

function dipa() {
    # update in both directions
    echo "aza -> nya"
    sudo rsync -uavP azathoth:/var/cache/distfiles/ /var/cache/distfiles
    sudo rsync -uavP azathoth:/var/cache/packages/  /var/cache/packages
    echo "nya -> aza"
    sudo rsync -uavP /var/cache/distfiles/ azathoth:/var/cache/distfiles
    sudo rsync -uavP /var/cache/packages/  azathoth:/var/cache/packages
}

function up() {
    # config
    uep
    # repos
    ur
    rsync -avP --delete rsync://azathoth/gentoo-layman /var/lib/layman/
    dipa
    sudo emerge --sync
    
    # eix
    eix-update

    # clean-up
    echo -n "cleaning up..."
    azash "find ~/ -mount -name '*.unison.tmp*' -delete" &
    find ~/ -mount -name "*.unison.tmp*" -delete &
    wait
    echo "done."
}
