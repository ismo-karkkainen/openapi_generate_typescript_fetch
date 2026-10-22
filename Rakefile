# frozen_string_literal: true

require 'rubocop/rake_task'

OGTF = 'openapi_generate_typescript_fetch'

task default: [:install]

desc 'Clean.'
task :clean do
  sh "rm -f #{OGTF}-*.gem"
end

desc 'Build gem.'
task gem: [:clean] do
  sh "gem build #{OGTF}.gemspec"
end

desc 'Build and install gem.'
task install: [:gem] do
  sh "gem install #{OGTF}-*.gem"
end

desc 'Uninstall gem.'
task :uninstall do
  sh "gem uninstall --executables #{OGTF}"
end

RuboCop::RakeTask.new(:lint) do |t|
  t.patterns = [ 'lib', "#{OGTF}.gemspec" ]
end
