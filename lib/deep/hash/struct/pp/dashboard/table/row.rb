module Deep
  module Hash
    module Struct
      module PP
        module Dashboard
          module Table
            module Row
              def inspect
                attributes  = []
                attributes << "name=#{name}"   unless name.nil?
                attributes << "value=#{value}" unless value.nil?
                attributes = "#{attributes.size.zero? ? '' : ' '}#{attributes.join(' ')}"
                "#<#{self.class.name.split("::").last}#{attributes}>"
              end

              def pretty_print(q)
                q.group(2, "#(#{self.class.name}:#{sprintf("0x%x", object_id)} {", "})") do
                  q.breakable

                  q.group(2, ":opt => {", "}") do
                    q.breakable
                    q.seplist(opt) do |k, v|
                      q.text ":#{k} => "
                      q.pp v
                    end
                    q.breakable
                  end

                  q.breakable

                  q.text ":name => "
                  q.pp name

                  q.breakable

                  q.text ":value => "
                  q.pp value

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