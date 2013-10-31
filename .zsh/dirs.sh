# named directories
typeset -A NAMED_DIRS
NAMED_DIRS=(
  0g             ~/Dropbox/0german
  gdict          ~/src/linguistics/german_dictionaries
  gems           $(gem environment gemdir)/gems
  german         ~/spoiler/languages/german
  greengen       ~/src/instruction/german_greengen
  lets           ~/Dropbox/LET\'S\ SING\ THE\ SHARING\ SONG\ YAY
  maff           ~/Dropbox/0german/canoonet_grammar/
  nfs            /mnt/nfs/
  plocal         /usr/local/portage/local
  src            ~/src
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
    printf "%10s --> %s\n" $key  ${NAMED_DIRS[$key]}
  done | sort -b
}
