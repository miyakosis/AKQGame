# 先行・後攻および手番プレイヤーを管理するクラス
class Order
	attr_reader :current, :opponent

	def initialize(player1, player2)
		if rand(2) == 0
			@first = player1
			@second = player2
		else
			@first = player2
			@second = player1
		end
		@current = @first
		@opponent = @second
	end

	def next_game!()
		@first, @second = @second, @first

		@current = @first
		@opponent = @second
	end

	def next_turn!()
		@current, @opponent = @opponent, @current
	end
end

