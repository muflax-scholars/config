# ~/local dir
export PATH="$HOME/local/bin:$PATH"
export MANPATH="$HOME/local/share/man:$MANPATH"
export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"

# ~/in/scripts
SCRIPTS="$HOME/local/src/in/scripts"
# adding scripts and all subdirs to PATH
for dir in $(find $SCRIPTS -type d -not -path "*/.git*"); do
  PATH="$dir:$PATH"
done

# R
export R_LIBS="$HOME/local/R"

# rbenv sets everything for ruby
PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
