module Deep
  module Hash
    module Struct
      class Dashboard
        class Table
          class Tr
            include PP::Dashboard::Table::Tr

            attr_accessor :header, :body, :side, :options

            def initialize(header, body, side, options = {})
              @header  = header
              @body    = body
              @side    = side
              @options = options
            end

            def th(value = nil)
              hash = {}
              if !value.is_a?(Array) && value.respond_to?(:each)
                if value.has_key?(:key) && value.has_key?(:value)
                  hash[value[:key]] = value[:value]
                else
                  value.each do |k, v|
                    hash[k] = v
                  end
                end
              else
                i = if options[:side]
                      side.count + 1
                    elsif options[:matrix]
                      header.count
                    else
                      header.count + 1
                    end
                hash["key_#{i}"] = value
              end

              if options[:side]
                side.merge! hash
              else
                header.merge! hash
              end

              value
            end

            def td(value = nil)
              hash = {}
              if !value.is_a?(Array) && value.respond_to?(:each)
                if value.has_key?(:key) && value.has_key?(:value)
                  hash[value[:key]] = value[:value]
                else
                  value.each do |k, v|
                    hash[k] = v
                  end
                end
              else
                i = body.count + 1
                hash["key_#{i}"] = value
              end

              if options[:side]
                hash.each do |k, v|
                  body[k][side.keys[options[:b_index]]] = v
                end
              else
                body.merge! hash
              end
            end
          end
        end
      end
    end
  end
end
