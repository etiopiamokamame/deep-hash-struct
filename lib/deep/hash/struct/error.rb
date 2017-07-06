module Deep
  module Hash
    module Struct
      module Error
        class UndefinedHeader < StandardError; end
        class UndefinedSide < StandardError; end
        class InvalidHeader < StandardError; end
        class InvalidSide < StandardError; end
        class UnnecessarySide < StandardError; end
        class HeaderRelated < StandardError; end
      end
    end
  end
end
