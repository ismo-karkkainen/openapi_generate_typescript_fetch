# frozen_string_literal: true

# Copyright © 2025-2026 Ismo Kärkkäinen
# Licensed under Universal Permissive License. See LICENSE.txt.

require_relative 'lib/openapi_generate_typescript_fetch/version'
require 'simpleidn'
require 'rake'


Gem::Specification.new do |s|
  ogtf = OpenAPIGenerateTypeScriptFetch::NAME
  s.name        = OpenAPIGenerateTypeScriptFetch::NAME
  s.version     = OpenAPIGenerateTypeScriptFetch::VERSION
  s.summary     = 'Generate Typescript Fetch API client package using OpenAPI format API specification.'
  s.description = 'This is a processor gem for use with openapi-generate from gem
openapi-sourcetools.

Produces a Fetch API client in TypeScript wrapped into a NPM package.'
  s.authors     = [ 'Ismo Kärkkäinen' ]
  s.email       = 'ismokarkkainen@icloud.com'
  s.files       = FileList[ "lib/#{ogtf}.rb", "lib/#{ogtf}/*.rb", 'template/*.erb', 'template/**/*.erb', 'LICENSE.txt' ]
  s.homepage    = "https://#{SimpleIDN.to_ascii('ismo-kärkkäinen.fi')}/#{ogtf}/index.html"
  s.license     = 'UPL-1.0'
  s.required_ruby_version = '>= 3.2.0'
  s.metadata = { 'rubygems_mfa_required' => 'true' }
  s.add_dependency 'lucky_case', '~> 1.1', '>= 1.1.0'
  s.add_dependency 'openapi-arrangement', '~> 0', '>= 0.1.0'
  s.add_dependency 'openapi-sourcetools', '~> 0', '>= 0.12.1'
end
