Gem::Specification.new do |s|
  s.name = "muflax-system"
  s.version = "1.0"

  s.authors = ["muflax"]
  s.summary = "muflax system gems"
  s.description = "gems that muflax uses system-wide"
  s.email = "mail@muflax.com"
  s.license = "GPL-3"

  s.add_dependency("beeminder")
  s.add_dependency("muflax")
  s.add_dependency("backup-urls")
end
