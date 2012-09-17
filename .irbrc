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
%w{awesome_print date json yaml}.each do |gem|
  begin
    require gem
  rescue LoadError => err
    warn "Couldn't load #{gem}: #{err}"
  end
end
