require "json"
<<<<<<< HEAD
require "deep/hash/struct/pp"
require "deep/hash/struct/wrapper"
require "deep/hash/struct/dashboard"
require "deep/hash/struct/error"
=======

module Deep
  module Hash
    module Struct
      class Wrapper
        def initialize(h = {})
          return if h.nil? || h.count.zero?
          wrap h, self
        end

        def keys
          instance_variables.map do |k|
            k.to_s[1..-1].to_sym
          end
        end

        def [](k)
          __send__ k
        end

        def []=(k, v)
          __send__ "#{k}=", v
        end

        def each
          keys.each do |k|
            yield k, self[k]
          end
        end

        def each_with_index(i = 0)
          keys.each do |k|
            yield [k, self[k]], i
            i += 1
          end
        end

        def count
          keys.size
        end
        alias size count

        def values
          keys.map do |k|
            self[k]
          end
        end

        def blank?
          keys.size.zero?
        end

        def present?
          !blank?
        end

        def dig(*syms)
          syms.reduce(self) do |h, k|
            h[k] if h.keys.include? k
          end
        rescue
          nil
        end

        def merge(hash)
          klass = self.dup

          hash.each do |k, v|
            klass[k] = v
          end

          klass
        end

        def merge!(hash)
          hash.each do |k, v|
            self[k] = v
          end
          self
        end

        def deep_merge(hash)
          klass = self.dup

          hash.each do |k , v|
            klass[k] = hash?(v) ? deep_merge(v) : v
          end

          klass
        end

        def deep_merge!(hash, klass = self)
          hash.each do |k, v|
            klass[k] = hash?(v) ? deep_merge!(v, klass[k]) : v
          end

          klass
        end

        def fetch(k, msg = nil)
          v = self[k]
          if block_given?
            if v.class == self.class || v.nil?
              yield k
            else
              v
            end
          else
            case v
            when self.class
              if v.blank?
                msg
              else
                to_h
              end
            when nil
              msg
            else
              v
            end
          end
        end

        def to_hash
          deep_hash self
        end
        alias to_h to_hash

        def to_json
          to_h.to_json
        end

        def method_missing(method_name, arg = nil)
          name = method_name.to_s.delete("=")

          if method_name.to_s.end_with? "="
            keys << name.to_sym unless keys.include? name.to_sym
            instance_variable_set "@#{name}", hash?(arg) ? wrap(arg) : arg
          else
            val = instance_variable_get "@#{name}"
            return val unless val.nil?
            instance_variable_set "@#{name}", self.class.new
          end
        rescue => e
          super
        end

        private

        def deep_hash(klass)
          h = {}

          klass.each do |k, v|
            h[k] = v.class == self.class ? deep_hash(v) : v
          end

          h
        end

        def wrap(hash, klass = nil)
          base = klass || self.class.new

          hash.each do |k, v|
            base[k] = hash?(v) ? wrap(v) : v
          end

          base
        end

        def hash?(val)
          !val.is_a?(Array) && val.respond_to?(:each)
        end
      end
    end
  end
end
>>>>>>> add merge, fetch and initialize
