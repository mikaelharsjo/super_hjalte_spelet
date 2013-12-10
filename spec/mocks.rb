# Simulates a CGPoint
module Mocks
	class CGPoint
		attr_accessor :x, :y

		def initialize(x, y)
			@x = x
			@y = y
		end

		def ==(other)
			@x == other.x && @y == other.y
		end
	end

	class Body
		attr_accessor :position

		def initialize(x, y)
			@x = x
			@y = y
			@position = CGPoint.new @x, @y
		end
	end
end