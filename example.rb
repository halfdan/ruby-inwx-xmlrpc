require "INWX/DomainRobot"
require "YAML"

# addr = "api.ote.domrobot.com"
addr = "api.domrobot.com"
user = "your_username"
pass = "your_password"
lang = "en"

domainRobot = INWX::DomainRobot.new(addr, user, pass, lang, true)

object = "domain"
method = "info"

params = { :domain => "software1987.de" }

result = domainRobot.call(object, method, params)

puts YAML::dump(result)
