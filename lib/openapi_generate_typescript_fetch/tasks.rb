# frozen_string_literal: true

# Copyright © 2024-2025 Ismo Kärkkäinen
# Licensed under Universal Permissive License. See LICENSE.txt.

require 'lucky_case'


# Namespace for functions with supposedly only internal use.
module OpenAPIGenerateTypeScriptFetch
  def self.template_directory
    File.join(File.dirname(__FILE__), '..', '..', 'template')
  end
  private_class_method :template_directory

  def self.template_names
    [ # File order is important.
      'initialize.sh.erb',
      'src/helpers.ts.erb',
      'src/server.ts.erb',
      'src/types.ts.erb',
      'src/functions.ts.erb',
      'src/index.ts.erb',
      'test/index.js.erb'
    ]
  end

  def self.full_template_name(template_name)
    File.join(template_directory, template_name)
  end

  def self.license
    File.read(File.join(template_directory, '..', 'LICENSE.txt'))
  end
end
