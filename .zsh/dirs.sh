# named directories
typeset -A NAMED_DIRS
NAMED_DIRS=(
  0g             ~/Dropbox/0german
  1t             ~/Dropbox/1toki\ pona
  lets           ~/Dropbox/LET\'S\ SING\ THE\ SHARING\ SONG\ YAY
  maff           ~/Dropbox/0german/canoonet_grammar

  layman         /var/lib/layman
  nfs            /mnt/nfs
  plocal         /usr/local/portage/local
  portage        /usr/portage

  src            ~/src
  gdict          ~/src/linguistics/german/lists
  muflax         ~/src/ruby/muflax
  scripts        ~/src/scripts
  ibus-steno     ~/src/typing/ibus/ibus-steno
  mavothi        ~/src/instruction/mavothi

  german         ~/spoiler/languages/german
  functionese    ~/spoiler/languages/functionese

  bgerman        ~/txt/languages/pie/germanic/german
  blatin         ~/txt/languages/pie/romance/latin
  bjapanese      ~/txt/languages/isolates/japanese
  brussian       ~/txt/languages/pie/slavic/russian
  blojban        ~/txt/languages/conlangs/loglan/lojban
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
