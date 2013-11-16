# Simulates a CGPoint
module Mocks
	class CGPoint
		attr_reader :x, :y

		def initialize(x, y)
			@x = x
			@y = y
		end
	end

	class Body
		def initialize(x, y)
			@x = x
			@y = y
		end

		def position
			CGPoint.new @x, @y
		end
	end
end