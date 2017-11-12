require "deep/hash/struct/dashboard/table/row"
require "deep/hash/struct/dashboard/table/tr"

module Deep
  module Hash
    module Struct
      class Dashboard
        class Table
          include PP::Dashboard::Table

          attr_accessor :opt,
                        :header,
                        :headers,
                        :side,
                        :sides,
                        :body,
                        :bodies,
                        :rows

          def initialize(options = {})
            self.opt           = default_options.merge(options)
            self.header        = Wrapper.new
            self.side          = Wrapper.new
            self.body          = []
            self.bodies        = []
            self.rows          = []
            header.side_header = opt[:side_header] if matrix?
          end

          def matrix?
            opt[:matrix]
          end

          def add_header
            yield header
          end

          def add_side
            yield side
          end

          def add_body
            yield b = Wrapper.new
            body << b
          end

          def parse!
            raise_check!

            self.headers = header.map.each_with_index do |(k, v), i|
              Row.new(header: true, side: matrix? && i.zero?, name: v, value: k)
            end

            self.sides = side.map do |k, v|
              Row.new(side: true, name: v, value: k)
            end

            self.bodies = if matrix?
                            bs = Wrapper.new

                            body.size.times do
                              bs.deep_merge! body.shift
                            end

                            sides.map do |s|
                              rs  = []
                              rs << s
                              rs += headers.map do |h|
                                next if h.side_header?
                                v = bs.to_h.dig(h.value, s.value)
                                v = v.nil? ? opt[:default] : v
                                Row.new(value: v)
                              end.compact
                              rs
                            end
                          else
                            body.map do |r|
                              headers.map do |h|
                                v = r.to_h.dig(h.value)
                                v = v.nil? ? opt[:default] : v
                                Row.new(value: v)
                              end.compact
                            end
                          end

            self.rows << headers
            self.rows += bodies
          end

          def each
            if block_given?
              rows.each do |r|
                yield r
              end
            else
              rows.each
            end
          end

          def map
            if block_given?
              rows.map do |r|
                yield r
              end
            else
              rows.map
            end
          end
          alias collect map

          def tr(options = {})
            b             = Wrapper.new
            opt[:side]    = options[:side] || false
            opt[:matrix]  = matrix?
            opt[:b_index] =  body.size

            yield Tr.new(header, b, side, opt)
            body << b unless b.count.zero?
            self
          end

          private

          def default_options
            {
              matrix: false
            }
          end

          def raise_check!
            raise Error::UndefinedHeader if header.blank?
            raise Error::UndefinedSide   if matrix? && side.blank?
            raise Error::InvalidHeader   if header.max_stages >= 2
            raise Error::InvalidSide     if matrix? && side.max_stages >= 2
            raise Error::UnnecessarySide if !matrix? && side.present?
            if matrix?
              body.each do |row|
                row.keys.each do |r|
                  next if header.keys[1..-1].include?(r) && row[r].keys.map { |c| side.include?(c) }.all?
                  raise Error::HeaderRelated
                end
              end
            else
              body.each do |row|
                row.keys.each do |r|
                  next if header.include?(r)
                  raise Error::HeaderRelated
                end
              end
            end
          end
        end
      end
    end
  end
end
