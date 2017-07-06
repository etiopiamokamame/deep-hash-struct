module Deep
  module Hash
    module Struct
      module PP
        module Dashboard
          module Table
            def inspect
              "#<#{self.class.name.split("::").last} matrix=#{matrix?}>"
            end

            def pretty_print(q)
              q.group(2, "#(#{self.class.name}:#{sprintf("0x%x", object_id)} {", "})") do
                q.breakable

                q.text ":matrix => "
                q.pp matrix?
                q.breakable

                unless headers.nil? || headers.size.zero?
                  q.group(2, ":headers => [", "]") do
                    q.breakable
                    q.seplist(headers) do |header|
                      q.pp header
                    end
                  end
                  q.breakable
                end

                unless sides.nil? || sides.size.zero?
                  q.group(2, ":sides => [", "]") do
                    q.breakable
                    q.seplist(sides) do |side|
                      q.pp side
                    end
                  end
                  q.breakable
                end

                unless bodies.size.zero?
                  q.group(2, ":bodies => [", "]") do
                    q.breakable
                    q.seplist(bodies) do |body|
                      q.group(2, "[", "]") do
                        q.breakable
                        q.seplist(body) do |row|
                          q.pp row
                        end
                        q.breakable
                      end
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
  end
end