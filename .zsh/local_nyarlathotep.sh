function up() {
    # config
    uep
    # repos
    ur
    rsync -avP --delete rsync://azathoth/gentoo-layman /var/lib/layman/
    udipa
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
