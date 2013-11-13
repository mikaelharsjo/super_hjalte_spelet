class DirectionCalculator
	include Direction

	# Todo: make fuzzy
	def self.direction(from, to)
		if from.y < to.y
			if from.x < to.x
				return NORTH_EAST
			end
			if from.x > to.x
				return NORTH_WEST
			end
			return NORTH
		end

		if from.y > to.y
			return SOUTH
		end

		STILL
	end
end