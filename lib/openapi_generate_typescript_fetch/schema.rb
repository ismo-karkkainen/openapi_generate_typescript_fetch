# frozen_string_literal: true

# Copyright © 2025 Ismo Kärkkäinen
# Licensed under Universal Permissive License. See LICENSE.txt.

require 'lucky_case'

# Namespace for functions with supposedly only internal use.
module OpenAPIGenerateTypeScriptFetch
  # Contains info about a property of an object schema.
  class ObjectSchemaProperty
    include Comparable

    attr_reader :name, :req, :type, :pattern, :additional, :spec

    def initialize(type:, spec:, name: nil, req: false, pattern: false, additional: false)
      @name = name
      @req = req
      @type = type
      @pattern = pattern
      @additional = additional
      @spec = spec
    end

    def <=>(other)
      return -1 if !@name.nil? && other.name.nil?
      return 1 if @name.nil? && !other.name.nil?
      d = @name <=> other.name
      return d unless d.zero?
      d = @pattern <=> other.pattern
      return d unless d.zero?
      d = @additional <=> other.additional
      return d unless d.zero?
      d = @type <=> other.type
      return d unless d.zero?
      @spec <=> other.spec
    end
  end

  # Common info about schema, used in multiple places so gathered here to shorten templates.
  class ObjectSchema
    attr_reader :props, :additional, :schema, :unknown_names
    def initialize(schema)
      raise ArgumentError, "#{schema['type']} not an object" unless schema['type'] == 'object'
      @schema = schema
      @props = []
      props = schema['properties'] || {}
      pat_props = schema['patternProperties'] || {}
      add_props = schema['additionalProperties']
      reqd = schema['required'] || []
      props.each do |name, spec|
        @props.push(ObjectSchemaProperty.new(
          name: name,
          req: reqd.include?(name),
          type: (Gen.h.category_and_name(spec) || [ spec['type'] ]).last,
          spec: spec
        ))
      end
      pat_props.each do |pattern, spec|
        @props.push(ObjectSchemaProperty.new(
          name: pattern,
          type: (Gen.h.category_and_name(spec) || [ spec['type'] ]).last,
          pattern: true,
          spec: spec
        ))
      end
      if add_props.is_a?(Hash)
        @additional = true
        @props.push(ObjectSchemaProperty.new(
          type: (Gen.h.category_and_name(add_props) || [ add_props['type'] ]).last,
          additional: true,
          spec: add_props
        ))
      elsif add_props.nil? || add_props == true
        @additional = true
        @props.push(ObjectSchemaProperty.new(
          type: nil,
          additional: true,
          spec: add_props
        ))
      else
        @additional = false
      end
      @props.sort!
      return if @additional
      if !pat_props.empty?
        # All patterns must have same failure cases.
        tps = Gen.x.cfg.dig(*%w[tests patterns])
        return if tps.nil?
        cands = nil
        @props.select(&:pattern).each do |p|
          pt = tps.index { |pc| pc['pattern'] == p.name }
          return if pt.nil?
          fails = tps[pt]['fail']
          return if fails.nil?
          cands = cands.nil? ? Set.new(fails) : cands & Set.new(fails)
          return if cands.empty?
        end
        cands -= Set.new(@props.reject(&:pattern).map(&:name))
        @unknown_names = cands.empty? ? nil : cands.to_a.sort!
      elsif !props.empty?
        fixed = @props.reject(&:pattern).map(&:name).map(&:size)
        @unknown_names = [ 'a' * (fixed.max + 1) ]
        @unknown_names.push('a') if fixed.min > 1
      else
        # No properties, pattern properties, no additional properties.
        @unknown_names = [ 'a' ]
      end
    end
  end
end
