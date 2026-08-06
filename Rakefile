# frozen_string_literal: true

require 'rubocop/rake_task'

def ogtf
  'openapi_generate_typescript_fetch'
end

task default: [:install]

desc 'Clean.'
task :clean do
  sh "rm -f #{ogtf}-*.gem"
end

desc 'Build gem.'
task gem: [:clean] do
  sh "gem build #{ogtf}.gemspec"
end

desc 'Build and install gem.'
task install: [:gem] do
  sh "gem install #{ogtf}-*.gem"
end

desc 'Uninstall gem.'
task :uninstall do
  sh "gem uninstall --executables #{ogtf}"
end

RuboCop::RakeTask.new(:lint) do |t|
  t.patterns = [ 'lib', "#{ogtf}.gemspec" ]
end
