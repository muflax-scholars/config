def load_gem gem, &block
  begin
    require gem
    block.call if block_given?
  rescue LoadError => err
    warn "Couldn't load #{gem}: #{err}, skipping..."
  end
end

# useful gems you want loaded by default
gems = %w{date json set yaml bayescraft muflax-chronic}
gems.each {|gem| load_gem gem}

# awesome_print
load_gem("awesome_print") {Pry.config.print = proc {|output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output)}}

# pry config
# Pry.config.theme = "monokai"
