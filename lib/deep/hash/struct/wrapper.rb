module Deep
  module Hash
    module Struct
      class Wrapper
        include PP::Wrapper

        attr_accessor :parent_ins,
                      :parent_key,
                      :chain

        attr_reader :default

        alias chain? chain

        def initialize(h = {}, opt = {})
          self.chain      = opt[:chain].nil? ? false : opt[:chain]
          self.parent_ins = opt[:parent_ins]
          self.parent_key = opt[:parent_key]
          return if h.nil? || h.count.zero?
          wrap h, self
        end

        def keys
          instance_variables.reject { |k| k =~ /default|parent_ins|parent_key|chain/ }.map do |k|
            k.to_s[1..-1].to_sym
          end
        end

        def values
          keys.map do |k|
            self[k]
          end
        end

        def [](k)
          __send__ k
        end

        def []=(k, v)
          __send__ "#{k}=", v
        end
        alias add []=

        def ==(hash)
          if hash.class == self.class
            to_h == hash.to_h
          else
            to_h == hash
          end
        end

        def ===(klass)
          self.class == klass
        end

        def each
          if block_given?
            keys.each do |k|
              yield k, self[k]
            end
          else
            to_h.each
          end
        end

        def each_with_index
          index = 0
          keys.each do |k|
            yield [k, self[k]], index
            index += 1
          end
        end

        def each_with_object(init)
          each do |k, v|
            yield [k, v], init
          end

          init
        end

        def each_key
          keys.each do |k|
            yield k
          end
        end

        def each_value
          values.each do |v|
            yield v
          end
        end

        def count
          keys.size
        end
        alias size count

        def blank?
          keys.size.zero?
        end

        def present?
          !blank?
        end

        def dig(*syms)
          syms.inject(self) do |h, k|
            h[k]
          end
        rescue
          nil
        end

        def merge(hash)
          klass = dup

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
        alias update merge!

        def deep_merge(hash, klass = self)
          klass = klass.deep_dup

          hash.each do |k , v|
            klass[k] = hash?(v) ? klass.deep_merge(v, klass[k]) : v
          end

          klass
        end

        def deep_merge!(hash, klass = self)
          hash.each do |k, v|
            klass[k] = hash?(v) ? deep_merge!(v, klass[k]) : v
          end

          klass
        end

        def reverse_merge(hash)
          klass = dup

          hash.each do |k, v|
            klass[k] = v if klass.exclude?(k)
          end

          klass
        end

        def reverse_merge!(hash)
          hash.each do |k, v|
            self[k] = v if exclude?(k)
          end

          self
        end

        def reverse_deep_merge(hash, klass = self)
          klass = klass.deep_dup

          hash.each do |k , v|
            next if !hash?(v) && klass.include?(k)
            klass[k] = hash?(v) ? klass.reverse_deep_merge(v, klass[k]) : v
          end

          klass
        end

        def reverse_deep_merge!(hash)
          hash.each do |k, v|
            next if !hash?(v) && include?(k)
            self[k] = hash?(v) ? reverse_deep_merge(v, self[k]) : v
          end

          self
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

        def map
          if block_given?
            vs = []

            each do |k, v|
              vs << yield(k, v)
            end

            vs
          else
            to_h.map
          end
        end
        alias collect map

        def map_key
          vs = []

          keys.each do |k|
            vs << yield(k)
          end

          vs
        end

        def map_value
          vs = []

          values.each do |v|
            vs << yield(v)
          end

          vs
        end

        def fetch_values(*syms)
          syms.map do |sym|
            if block_given?
              if keys.include?(sym)
                self[sym]
              else
                yield sym
              end
            else
              raise KeyError, "key not found: :#{sym}" unless keys.include?(sym)
              self[sym]
            end
          end
        end

        def values_at(*syms)
          syms.map do |sym|
            v = self[sym]
            (v.nil? || (v.class == self.class && v.blank?)) ? nil : v
          end
        end

        def invert
          each_with_object({}) do |(k, v), h|
            h[v] = k
          end
        end

        def delete(k)
          remove_instance_variable "@#{k}"
        end

        def delete_if
          each do |k, v|
            remove_instance_variable "@#{k}" if yield(k, v)
          end
          self
        end

        def find
          klass = self.class.new

          each do |k, v|
            if yield(k, v)
              klass[k] = v
              break
            end
          end

          klass
        end

        def select
          klass = self.class.new

          each do |k, v|
            klass[k] = v if yield(k, v)
          end

          klass
        end
        alias find_all select

        def reject
          klass = self.class.new

          each do |k, v|
            klass[k] = v unless yield(k, v)
          end

          klass
        end

        def reject!
          each do |k, v|
            remove_instance_variable "@#{k}" if yield(k, v)
          end
          self
        end

        def inject(init = 0)
          value = [Float, Fixnum].include?(init.class) ? init : init.dup
          each do |k, v|
            val = yield [Float, Fixnum].include?(init.class) ? init : init.dup, [k, v]
            next if val.nil?
            value += val
          end
          value
        end
        alias reduce inject

        def clear
          remove_instance_variable "@default" unless default.nil?
          each_key do |k|
            remove_instance_variable "@#{k}"
          end
          self
        end

        def replace(other)
          h = if other.class == self.class
                other.to_hash
              elsif hash? other
                other
              else
                other.to_hash
              end

          clear
          wrap h, self
        end

        def flatten
          to_h.flatten
        end

        def has_key?(k)
          keys.include? k
        end
        alias include? has_key?

        def has_keys?(*syms)
          syms.inject(self) do |klass, sym|
            val = klass[sym]
            return false if val.class == self.class && val.blank?
            klass[sym]
          end
          true
        end

        def exclude?(k)
          !include? k
        end

        def sort
          to_h.sort
        end

        def shift
          k = keys.first
          [k, remove_instance_variable("@#{k}")]
        end

        def to_a
          to_h.to_a
        end
        alias to_ary to_a

        def compact
          klass = dup

          klass.each do |k, v|
            klass.remove_instance_variable("@#{k}") if (v.class == self.class && v.blank?) || v.nil?
          end

          klass
        end

        def compact!
          each do |k, v|
            remove_instance_variable("@#{k}") if (v.class == self.class && v.blank?) || v.nil?
          end

          self
        end

        def deep_compact
          klass = deep_dup

          klass.each do |k, v|
            flag  = if v.class == self.class
                      klass[k] = v.deep_compact
                      klass[k].present?
                    else
                      !v.nil?
                    end
            next if flag
            klass.remove_instance_variable("@#{k}")
          end

          klass
        end

        def deep_compact!
          each do |k, v|
            flag  = if v.class == self.class
                      self[k] = v.deep_compact
                      self[k].present?
                    else
                      !v.nil?
                    end
            next if flag
            remove_instance_variable("@#{k}")
          end

          self
        end

        def slice(*syms)
          klass = self.class.new

          each_key do |k|
            klass[k] = self[k] if syms.map(&:to_sym).include?(k)
          end

          klass
        end

        def slice!(*syms)
          each_key do |k|
            remove_instance_variable("@#{k}") unless syms.map(&:to_sym).include?(k)
          end

          self
        end

        def to_hash
          deep_hash self
        end
        alias to_h to_hash

        def to_json
          to_h.to_json
        end

        def max_stages(klass = self, i = 1)
          klass.map_value do |v|
            case v
            when self.class
              max_stages v, i + 1
            else
              i
            end
          end.sort.last || 0
        end

        def min_stages(klass = self, i = 1)
          klass.map_value do |v|
            case v

            when self.class
              min_stages v, i + 1
            else
              i
            end
          end.delete_if(&:zero?).sort.first || 0
        end

        def to_table(side_name = nil)
          if min_stages >= 2
            values.flat_map(&:keys).uniq.map do |side|
              map_value { |v| v[side] }.unshift side
            end.unshift keys.unshift(side_name)
          else
            deep_table to_h
          end
        end

        def deep_dup(klass = self)
          new_klass = self.class.new

          klass.each do |k, v|
            new_klass[k] = hash?(v) ? v.deep_dup(v) : v
          end

          new_klass
        end

        private

        def method_missing(method_name, arg = nil)
          name = method_name.to_s.delete("=")

          if method_name.to_s.end_with? "="
            setting_chain_instance!(self, name, arg)
          elsif block_given?
            __send__ "#{name}=", yield
          else
            val = instance_variable_get "@#{name}"
            return val unless val.nil?
            return self.class.new({}, chain: true, parent_ins: self, parent_key: method_name) if default.nil?
            default
          end
        rescue => e
          e.backtrace.shift
          raise
        end

        def chain!
          self.chain = true
        end

        def setting_chain_instance!(klass, key, val)
          klass.instance_variable_set "@#{key}", hash?(val) && (!(self === val.class) || klass.chain?) ? wrap(val) : val
          return val unless klass.chain?
          setting_chain_instance!(klass.parent_ins, klass.parent_key, klass)
        end

        def deep_hash(klass)
          h = {}

          klass.each do |k, v|
            h[k]  = if v.class == self.class
                      deep_hash(v) if v.present?
                    else
                      v
                    end
          end

          h
        end

        def deep_table(hash)
          hash.to_a.transpose.map do |val|
            val.map do |v|
              if hash? v
                deep_table v
              else
                v
              end
            end
          end
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
