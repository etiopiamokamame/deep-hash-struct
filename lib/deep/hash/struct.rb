require "deep/hash/struct/version"
require "json"

module Deep
  module Hash
    module Struct
      class Wrapper
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

        def wrap(hash)
          base = self.class.new

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
