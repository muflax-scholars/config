# named directories

typeset -A NAMED_DIRS
NAMED_DIRS=(
  # system stuff
  layman          /var/lib/layman
  nfs             /mnt/nfs
  plocal          /usr/local/portage/local
  portage         /usr/portage
)
for key in ${(k)NAMED_DIRS}
do
  # only add paths that actually exist
  if [[ -d ${NAMED_DIRS[$key]} ]]; then
    hash -d $key=${NAMED_DIRS[$key]}
  fi
done

function lsdirs () {
  for key in ${(k)NAMED_DIRS}
  do
    printf "%15s --> %s\n" $key  ${NAMED_DIRS[$key]}
  done | sort -b
}
