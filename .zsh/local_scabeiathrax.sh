function fun() {
  # full sync of laptop

  # sync configs
  un

  # sync git-annex
  git_annex_sync.sh
  git_annex_get_auto.sh

  # clean-up
  # echo -n "cleaning up..."
  # azash "find ~/ -mount -name '*.unison.tmp*' -delete" &
  # find ~/ -mount -name "*.unison.tmp*" -delete &
  # wait
  # echo "done."
}
