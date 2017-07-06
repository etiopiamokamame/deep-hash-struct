module Deep
  module Hash
    module Struct
      module PP
        module Dashboard
          def inspect
              "#<#{self.class.name.split("::").last}>"
          end

          def pretty_print(q)
            q.group(2, "#(#{self.class.name}:#{sprintf("0x%x", object_id)} {", "})") do
              q.breakable

              q.group(2, ":tables => [", "]") do
                q.breakable
                q.seplist(tables) do |table|
                  q.pp table
                end
                q.breakable
              end

              q.breakable
            end
          end
        end
      end
    end
  end
end