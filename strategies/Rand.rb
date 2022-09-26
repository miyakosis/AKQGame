# ƒ‰ƒ“ƒ_ƒ€‚É 1/3 ‚Å fold, 1/3 ‚Å call, 1/3 ‚Å raise ‚ð‘I‘ð‚·‚é
class Rand < Strategy
	def get_id()
		101
	end
	
	def game_start(amount, amount_opponent, order, pot_ante, hand)
		@amount = amount
	end

	def action(turn, bet, bet_opponent)
		case rand(3)
		when 0
			fold()
		when 1
			call(bet_opponent)
		when 2
			raise(bet, bet_opponent)
		end
	end
	
private
	def fold()
		-1
	end
	
	def call(bet_opponent)
		[bet_opponent, @amount].min
	end
	
	def raise(bet, bet_opponent)
		[bet_opponent + (bet_opponent - bet), @amount].min
	end
end
