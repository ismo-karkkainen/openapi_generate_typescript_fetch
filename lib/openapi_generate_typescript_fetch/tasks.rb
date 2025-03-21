# frozen_string_literal: true

# Copyright © 2024-2026 Ismo Kärkkäinen
# Licensed under Universal Permissive License. See LICENSE.txt.

require_relative 'schema' # For templates.
require 'lucky_case'
require 'uri'

# Namespace for functions with supposedly only internal use.
module OpenAPIGenerateTypeScriptFetch
  def self.template_directory
    File.join(File.dirname(__FILE__), '..', '..', 'template')
  end
  private_class_method :template_directory

  def self.template_names
    [ # Consider import order when ordering these files.
      'package.json.erb',
      'tsconfig.json.erb',
      'src/helpers.ts.erb',
      'src/servers.ts.erb',
      'src/schemas.ts.erb',
      'src/shared.ts.erb',
      'src/callclasses.ts.erb',
      'src/index.ts.erb',
      'test/helpers.ts.erb',
      'test/makers.ts.erb',
      'test/schemas.ts.erb',
      'test/shared.ts.erb',
      'test/servers.ts.erb',
      'test/callclasses.ts.erb'
    ]
  end

  def self.full_template_name(template_name)
    File.join(template_directory, template_name)
  end

  def self.license
    File.read(File.join(template_directory, '..', 'LICENSE.txt'))
  end
end
