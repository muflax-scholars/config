# useful gems you want loaded by default
gems = %w{date json set yaml bayescraft muflax-chronic}

gems.each do |gem|
  begin
    require gem
  rescue LoadError => err
    warn "Couldn't load #{gem}: #{err}, skipping..."
  end
end

# awesome_print
begin
  require "awesome_print"
  Pry.config.print = proc { |output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output) }
rescue LoadError => err
  puts "no awesome_print :("
end
