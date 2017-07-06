module Deep
  module Hash
    module Struct
      module PP
        module Wrapper
          def inspect
            v = blank? ? nil : " #{to_h}"
            "#<#{self.class.name.split("::").last}#{v}>"
          end

          def pretty_print(q)
            q.group(2, "#(#{self.class.name}:#{sprintf("0x%x", object_id)} {", "})") do
              q.breakable

              q.group(2, "{", "}") do
                q.breakable
                pretty_print_cycle(q)
              end

              q.breakable
            end
          end

          def pretty_print_cycle(q, hash = to_h)
            q.seplist(hash) do |k, v|
              q.text ":#{k} =>"
              if [String, Integer].include?(v.class)
                q.pp v
              else
                q.group(2, "{", "}") do
                  q.breakable
                  pretty_print_cycle(q, v)
                end
              end
            end
          end
        end
      end
    end
  end
end