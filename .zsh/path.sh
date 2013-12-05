# ~/local dir
export PATH="$HOME/local/bin:$PATH"
export MANPATH="$HOME/local/share/man:$MANPATH"
export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"

# local scripts; consider merging with config?
SCRIPTS="$HOME/src/scripts"
# adding scripts and all subdirs to PATH
for dir in $(find $SCRIPTS -type d -not -path "*/.git*"); do
  export PATH="$dir:$PATH"
done

# R
export R_LIBS="$HOME/local/R"

# rbenv loads most gems
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
# but prefer bundler's version if it exists
export PATH="$HOME/.bundle/bin:$PATH"
