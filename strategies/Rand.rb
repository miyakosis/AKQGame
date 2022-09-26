# �����_���� 1/3 �� fold, 1/3 �� call, 1/3 �� raise ��I������
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
