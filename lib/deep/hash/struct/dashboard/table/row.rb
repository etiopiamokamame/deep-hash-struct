module Deep
  module Hash
    module Struct
      class Dashboard
        class Table
          class Row
            include PP::Dashboard::Table::Row

            attr_accessor :opt,
                          :name,
                          :value

            def initialize(options = {})
              self.value = options.delete(:value)
              self.name  = options.delete(:name)
              self.opt   = default_options.merge(options)
            end

            def header?
              opt[:header]
            end

            def side?
              opt[:side]
            end

            def side_header?
              header? && side?
            end

            private

            def default_options
              {
                header: false,
                side:   false
              }
            end
          end
        end
      end
    end
  end
end
