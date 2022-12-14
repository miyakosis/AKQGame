# A の時は raise, Q の時は fold、K の時は 1/3 ずつで raise, fold, call を選択する
class Honest < Strategy
	def get_id()
		102
	end
	
	def game_start(amount, amount_opponent, order, pot_ante, hand)
		@hand = hand
		@amount = amount
	end

	def action(turn, bet, bet_opponent)
		case @hand
		when 0
			fold()
		when 1
			case rand(3)
			when 0
				fold()
			when 1
				call(bet_opponent)
			when 2
				raise(bet, bet_opponent)
			end
		when 2
			raise(bet, bet_opponent)
		end
	end

private
	def fold
		-1
	end
	
	def call(bet_opponent)
		[bet_opponent, @amount].min
	end
	
	def raise(bet, bet_opponent)
		[bet_opponent + (bet_opponent - bet), @amount].min
	end
end
