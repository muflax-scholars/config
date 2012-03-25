require 'rubygems'

# wirble
begin
  require 'wirble'

  # start wirble (with color)
  Wirble.init
  Wirble.colorize
rescue LoadError => err
  warn "Couldn't load Wirble: #{err}"
end

begin
  require 'awesome_print'
rescue LoadError => err
  warn "Couldn't load awesome_print: #{err}"
end
