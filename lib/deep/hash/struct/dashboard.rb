require "deep/hash/struct/dashboard/table"

module Deep
  module Hash
    module Struct
      class Dashboard
        include Struct::PP::Dashboard

        attr_accessor :tables

        def initialize
          self.tables = []
        end

        def add_table(options = {})
          tables << if block_given?
                      yield table = Table.new(options)
                      table.parse!
                      table
                    else
                      Table.new
                    end
        end

        def each
          if block_given?
            tables.each do |table|
              yield table
            end
          else
            tables.each
          end
        end

        def map
          if block_given?
            tables.map do |table|
              yield table
            end
          else
            tables.map
          end
        end
        alias collect map
      end
    end
  end
end
