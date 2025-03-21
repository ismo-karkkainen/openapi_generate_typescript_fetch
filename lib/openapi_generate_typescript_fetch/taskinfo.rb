# frozen_string_literal: true

# Copyright © 2025 Ismo Kärkkäinen
# Licensed under Universal Permissive License. See LICENSE.txt.

require_relative 'version'

module OpenAPIGenerateTypeScriptFetch
  # For storing names for imports.
  class ExportedNames
    attr_reader :basename, :types, :functions, :consts, :interfaces, :enums, :classes

    def initialize(basename)
      @basename = basename
      @types = []
      @functions = []
      @consts = []
      @interfaces = []
      @enums = []
      @classes = []
    end

    def imports
      [].concat(@functions, @consts, @interfaces, @enums, @classes).sort!
    end

    def import_types
      @types.sort
    end
  end

  # For use as Gen.x.
  class TaskInfo
    attr_reader :cfg, :order, :gem_name, :gem_version
    attr_accessor :generator_info
    attr_reader :schemas, :servers, :shared, :callclasses, :makers
    attr_accessor :server_data

    def initialize(config, order)
      @cfg = config
      @order = order
      @gem_name = OpenAPIGenerateTypeScriptFetch::NAME
      @gem_version = OpenAPIGenerateTypeScriptFetch::VERSION
      @schemas = ExportedNames.new('schemas')
      @servers = ExportedNames.new('servers')
      @shared = ExportedNames.new('shared')
      @callclasses = ExportedNames.new('callclasses')
      @makers = ExportedNames.new('makers')
      @server_data = nil
    end
  end
end
