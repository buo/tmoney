lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tmoney/version'

Gem::Specification.new do |gem|
  gem.name        = 'tmoney'
  gem.version     = Tmoney::VERSION
  gem.authors     = ['buo']
  gem.email       = ['buo@users.noreply.github.com']
  gem.summary     = 'A simple client for T-Money'
  gem.description = 'A simple client for T-Money (https://www.t-money.co.kr/)'
  gem.homepage    = 'https://github.com/buo/tmoney'
  gem.license     = 'MIT'

  gem.files       = `git ls-files`.split($/)
  gem.require_paths = ['lib']
end
