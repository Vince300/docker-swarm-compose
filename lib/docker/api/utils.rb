module Docker
  module Api
    module Utils
      def self.snake_case(str)
        str.gsub(/([a-z])([A-Z])/, '\1_\2').
          tr("-", "_").
          downcase
      end
    end
  end
end