# frozen_string_literal: true

# Copyright © 2024-2026 Ismo Kärkkäinen
# Licensed under Universal Permissive License. See LICENSE.txt.

require_relative 'openapi_generate_typescript_fetch/tasks'
require_relative 'openapi_generate_typescript_fetch/version'
require_relative 'openapi_generate_typescript_fetch/taskinfo'
require 'openapi/sourcetools'
require 'openapi/arrangement'
require 'date'
require 'base64'

# Task initialization and helper code.
module OpenAPIGenerateTypeScriptFetch
  COPYRIGHT_DEFAULT = "Copyright #{Date.today.year} by the respective holders.
This is a default copyright notice. Substitute with your own in configuration.
(Use 'copyright' configuration key.)".freeze

  def self.config_defaults(cfg)
    ds = {
      'subdir' => '.',
      'copy' => [],
      'copyright' => COPYRIGHT_DEFAULT,
      'ts_indentation' => {
        'indent_character' => ' ',
        'indent_step' => 2,
        'tab' => "\t",
        'tab_replaces_count' => 0
      }
    }
    ds.each do |key, value|
      cfg[key] = value unless cfg.key?(key)
    end
    cfg
  end

  def self.setup_tasks
    # Configurations are read at this point to catch errors early.
    cfg = config_defaults(Gen.load_config(Gen.config || OpenAPIGenerateTypeScriptFetch::NAME))
    Gen.x = TaskInfo.new(cfg, OpenAPIArrangement::Schema.alphabetical(Gen.doc))
    cr = cfg['copyright'].lines.map! { |x| "// #{x}".rstrip }
    Gen.x.generator_info = <<EOB
#{cr.join("\n")}
//
// Generated code. Do not edit.
//
// Generated from #{Gen.doc.dig('info', 'title')} version #{Gen.doc.dig('info', 'version')}
// Gem name: #{OpenAPIGenerateTypeScriptFetch::NAME}
// Gem version: #{OpenAPIGenerateTypeScriptFetch::VERSION}
EOB
    setup_templates(OpenAPIGenerateTypeScriptFetch.template_names, cfg['subdir'])
    setup_copies(cfg['copy'], cfg['subdir'])
  end

  def self.gitignore
    <<EOB
coverage
coverage-reports
node_modules
pkg
EOB
  end

  def self.setup_templates(names, subdir)
    names.each do |template_name|
      f = OpenAPIGenerateTypeScriptFetch.full_template_name(template_name)
      template = File.read(f)
      name = File.join(subdir, template_name[0..-5]) # Drop '.erb'
      executable = name.upcase.end_with?('.SH')
      Gen.add(source: Gen.doc, template:, template_name:, name:, executable:)
    end
  end

  def self.obtain_content(root, info)
    # Expects 'target' and either 'content' or 'source'.
    content = info['content']
    return content unless content.nil?
    src = info['source']
    raise StandardError, "No copy file content or source name provided, copy target: #{info['target']}" if src.nil?
    begin
      File.binread(File.join(root, src))
    rescue Exception => e
      $stderr.puts("Failed to read copy file from source: '#{src}', copy target: #{info['target']}")
      raise e
    end
  end

  def self.setup_copies(copies, subdir)
    own_copies = [{
      'target' => 'mcr.config.json',
      'content' => '{"reports":["text","v8","v8-json","raw"],"entryFilter":"**/pkg/src/**"}'
    }]
    # Order allows easy overwrites from user's config.
    copies = [].concat(own_copies, copies)
    copies.size.times do |k|
      info = copies[k]
      name = info['target']
      raise StandardError, "No copy file target name provided, copy index: #{k - own_copies.size}" if name.nil?
      content = obtain_content(Gen.wd, info)
      Gen.add_write_content(name: File.join(subdir, name), content: content)
    end
  end
end

# Runs when the gem is loaded the first time from openapi-generate.
OpenAPIGenerateTypeScriptFetch.setup_tasks if defined?(Gen)
