module Deep
  module Hash
    module Struct
      module PP
        module Dashboard
          module Table
            module Tr
              def inspect
                attributes  = []
                attributes << "header=#{header}" if header.present?
                attributes << "side=#{side}"     if side.present?
                attributes << "body=#{body}"     if body.size > 0
                attributes << "options=#{options}"
                attributes  = "#{attributes.size.zero? ? '' : ' '}#{attributes.join(' ')}"
                "#<#{self.class.name.split("::").last}#{attributes}>"
              end

              def pretty_print(q)
                q.group(2, "#(#{self.class.name}:#{sprintf("0x%x", object_id)} {", "})") do
                  q.breakable

                  if header.present?
                    q.text ":header => "
                    q.pp header
                    q.breakable
                  end

                  if side.present?
                    q.text ":side => "
                    q.pp side
                    q.breakable
                  end

                  if body.size > 0
                    q.text ":body => "
                    q.pp body
                    q.breakable
                  end

                  q.group(2, ":options => {", "}") do
                    q.breakable
                    q.seplist(options) do |k, v|
                      q.text ":#{k} => "
                      q.pp v
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