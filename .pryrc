#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

def load_gem gem, &block
  begin
    require gem
    block.call if block_given?
  rescue LoadError => err
    warn "Couldn't load #{gem}: #{err}, skipping..."
  end
end

# useful gems you want loaded by default
gems = [
        "active_support",
        "bayescraft",
        "chronic",
        "date",
        "highline/import",
        "json",
        "range_math",
        "set",
        "yaml",
       ]
gems.each {|gem| load_gem gem}

# awesome_print
load_gem("awesome_print") {Pry.config.print = proc {|output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output)}}

# pry config
# Pry.config.theme = "monokai"
Pry.config.editor = "emacsclient -n -c"

# some aliases
Pry.config.commands.alias_command "ee", "edit"
