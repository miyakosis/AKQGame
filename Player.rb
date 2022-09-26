# Strategy ‚ğ•Û‚µAŒ»İ‚Ì bet ‚â amount ‚È‚Ç‚ğŠÇ—‚·‚éƒNƒ‰ƒX
class Player
	attr_accessor :bet
	attr_reader :amount, :hand, :strategy_id

	def initialize(strategy_name, amount, ante, n_games)
		require_relative "strategies/#{strategy_name}.rb"
		klass = Module.const_get(strategy_name)
		
		@strategy = klass.new
		@amount = amount
		@ante = ante
		@n_games = n_games
		@strategy_id = @strategy.get_id
	end
	
	def set_opponent(opponent)
		@opponent = opponent
	end

	def add_amount(addition)
		@amount += addition
	end

	def match_start()
		@strategy.strategy_initialize
		@strategy.match_start(@opponent.strategy_id, @amount, @ante, @n_games)
	end
	
	def match_end()
		@strategy.match_end(@amount, @opponent.amount)
		@strategy.strategy_terminate
	end

	def game_start(order, pot_ante, hand)
		@strategy.game_start(@amount, @opponent.amount, order, pot_ante, hand)
		@bet = 0
		@hand = hand
	end

	def action(turn)
		@strategy.action(turn, @bet, @opponent.bet)
	end

	def game_end(winner_id, pot, message)
		@strategy.game_end(@amount, @amount_opponent, winner_id, pot, message)
	end
end
