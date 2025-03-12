# frozen_string_literal: true

# Copyright © 2025 Ismo Kärkkäinen
# Licensed under Universal Permissive License. See LICENSE.txt.

require_relative 'version'

module OpenAPIGenerateTypeScriptFetch
  class ExportedNames
    attr_reader :types, :functions, :consts, :interfaces

    def initialize
      @types = []
      @functions = []
      @consts = []
      @interfaces = []
    end
  end

  # For use as Gen.x.
  class TaskInfo
    attr_reader :cfg, :order, :gem_name, :gem_version
    attr_accessor :generator_info
    attr_reader :types, :server

    def initialize(config, order)
      @cfg = config
      @order = order
      @gem_name = OpenAPIGenerateTypeScriptFetch::NAME
      @gem_version = OpenAPIGenerateTypeScriptFetch::VERSION
      @types = ExportedNames.new
      @server = ExportedNames.new
    end
  end
end
