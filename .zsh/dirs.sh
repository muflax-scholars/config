# named directories

typeset -A NAMED_DIRS
NAMED_DIRS=(
  # dropbox
  0g              ~/Dropbox/0german
  lets            ~/Dropbox/LET\'S\ SING\ THE\ SHARING\ SONG\ YAY
  maff            ~/Dropbox/0german/canoonet_grammar

  # system stuff
  layman          /var/lib/layman
  nfs             /mnt/nfs
  plocal          /usr/local/portage/local
  portage         /usr/portage

  # random projects
  src             ~/src
  muflax          ~/src/ruby/muflax
  scripts         ~/src/scripts
  ibus-steno      ~/src/typing/ibus/ibus-steno

  # german
  dudenbib        ~/src/linguistics/german/dudenbib
  duden           ~/src/linguistics/german/duden-analysis
  gdict           ~/src/linguistics/german/lists
  mavothi         ~/src/instruction/mavothi
  script-rec      ~/src/instruction/script-recorder

  # notes
  german          ~/spoiler/languages/german
  gpreds          ~/spoiler/languages/german/predicates

  # books
  bgerman         ~/txt/languages/pie/germanic/german
  blatin          ~/txt/languages/pie/romance/latin
  bjapanese       ~/txt/languages/isolates/japanese
  brussian        ~/txt/languages/pie/slavic/russian
  blojban         ~/txt/languages/conlangs/loglan/lojban
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
