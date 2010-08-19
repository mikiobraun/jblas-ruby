require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

spec = Gem::Specification.new do |s|
  s.name = 'jblas-ruby'
  s.author = "Mikio L. Braun"
  s.email = "mikiobraun@gmail.com"
  s.homepage = "http://mikiobraun.github.com/jblas-ruby"
  s.version = "1.1"
  s.summary = "jblas-ruby - Java based linear algebra for Ruby"
  s.platform = Gem::Platform::RUBY
  s.requirements << 'none'
  s.require_path = 'lib'
  s.files = Dir.glob 'lib/**/*.{rb,jar}'
  s.has_rdoc = true
  s.description = "Fast linear algebra for JRuby based on the jblas library."
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

desc 'run all tests in the test directory'
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = Dir.glob('test/**/test_*.rb')
  t.verbose = true
end

desc 'generate rdoc html'
task 'rdoc-html' do
  sh 'rm -rf doc'
  files = Dir.glob('lib/jblas/*.rb').sort + Dir.glob('lib/*.rb')
  sh "rdoc -S -f html #{files.join(' ')}"
end
