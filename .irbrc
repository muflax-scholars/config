require 'rubygems'

# wirble
begin
  require 'wirble'

  # start wirble (with color)
  Wirble.init
  Wirble.colorize
rescue LoadError => err
  warn "Couldn't load wirble: #{err}"
end

# useful gems
gems = %w{awesome_print date json set yaml bayescraft chronic}

gems.each do |gem|
  begin
    require gem
  rescue LoadError => err
    warn "Couldn't load #{gem}: #{err}, skipping..."
  end
end
