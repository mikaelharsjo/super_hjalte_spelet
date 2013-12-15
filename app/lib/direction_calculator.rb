class DirectionCalculator
	include Direction

	def self.direction(from, to)
		# make conditions a little fuzzy
		from.x = from.x.to_i
		from.y = from.y.to_i
		to.x = to.x.to_i
		to.y = to.y.to_i

		return STILL if from.x == to.x and from.y == to.y

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

		if from.y == to.y
			if from.x < to.x
				return EAST
			else
				return WEST	
			end
		end

		return WEST if from.x == to.y

		STILL
	end
end