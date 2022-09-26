require_relative "Strategy"
require_relative "Order"
require_relative "Player"

# 2つの Strategy を管理して match を進行するクラス
class Dealer

	AMOUNT = 100
	N_GAMES = 1000
	ANTE = 1
	HANDS = [0, 1, 2]

	# match を進行する
	def make_match(strategy1, strategy2)
		player1 = Player.new(strategy1, AMOUNT, ANTE, N_GAMES)
		player2 = Player.new(strategy2, AMOUNT, ANTE, N_GAMES)
		player1.set_opponent(player2)
		player2.set_opponent(player1)

		order = Order.new(player1, player2)

		player1.match_start()
		player2.match_start()

		game = 1
		while game <= N_GAMES && make_game(order, game) do
			game += 1
			order.next_game!
		end
		
		player1.match_end()
		player2.match_end()
		
		puts "game: #{game}, strategy1: #{strategy1} => result: #{player1.amount}, strategy2: #{strategy2} => result: #{player2.amount}"
	end

	# game の処理を行う
	def make_game(order, game)
		return false if order.current.amount == 0 || order.opponent.amount == 0

		order.current.add_amount(-1 * ANTE)
		order.opponent.add_amount(-1 * ANTE)
		pot_ante = ANTE * 2

		hands = HANDS.shuffle
		order.current.game_start(1, pot_ante, hands[0])
		order.opponent.game_start(2, pot_ante, hands[1])

		turn = 1
		while make_turn(order.current, order.opponent, turn, pot_ante) do
			turn += 1
			order.next_turn!
		end
		
		true
	end
	
	# turn の処理を行う
	def make_turn(current, opponent, turn, pot_ante)
		action = current.action(turn)

		# action 内容をチェックし、ルール違反があれば message に設定する
		message = check_action(action, current, opponent)

		if message
			# 違反があるので現在の player を負けとする
			end_game(opponent, current, pot_ante, message)
			return false
		elsif action < 0
			message = "fold by #{current.strategy_id}"
			end_game(opponent, current, pot_ante, message)
			return false
		end

		# fold ではない有効な bet であるため、bet額を保持しておく
		current.bet = action
		
		if turn == 1
			return true
		end

		if current.bet == opponent.bet
			# call
			showdown(current, opponent, pot_ante)
			return false
		elsif current.bet == current.amount && current.bet < opponent.bet
			# all in call
			opponent.bet = current.bet
			showdown(current, opponent, pot_ante)
			return false
		else
			return true
		end
	end



	# current の提出した action の内容が妥当かチェックする
	#
	# @param [Integer] action action
	# @param [Player] current 手番プレイヤー
	# @param [Player] opponent 非手番プレイヤー
	# @return [String] nil: ルールに違反していない message: ルール違反の詳細
	def check_action(action, current, opponent)
		minimum_raise = opponent.bet + (opponent.bet - current.bet)

		if action < 0
			# fold -> OK
			nil
		elsif action == current.amount
			# all in -> OK
			nil
		elsif action > current.amount
			# 現在の保有ポイントより大きい bet -> NG
			"fold by #{current.strategy_id} reason: invalid bet. current bet = #{action}, amount = #{current.amount} opponent bet = #{opponent.amount}"
		elsif action < opponent.bet
			# (all in ではない)相手の bet 額より小さい bet -> NG
			"fold by #{current.strategy_id} reason: invalid bet. current bet = #{action}, amount = #{current.amount} opponent bet = #{opponent.amount}"
		elsif action == opponent.bet
			# call or check -> OK
			nil
		elsif action < minimum_raise
			# raise 額に満たない bet -> NG
			"fold by #{current.strategy_id} reason: less than minimum raise.  current bet = #{action}, amount = #{current.amount} opponent bet = #{order.opponent.amount} minimum raise = #{minimum_raise}"
		else
			# raise -> OK
			nil
		end
	end

	# showdown の処理を行う
	def showdown(current, opponent, pot_ante)
		if current.hand > opponent.hand
			winner = current
			loser = opponent
		else
			winner = opponent
			loser = current
		end
		
		message = "winner #{winner.strategy_id} by #{winner.hand}, loser #{loser.strategy_id} by #{loser.hand}"
		end_game(winner, loser, pot_ante, message)
	end

	# game の終了処理を行う
	def end_game(winner, loser, pot_ante, message)
		pot = winner.bet + loser.bet + pot_ante
		loser.add_amount(-1 * loser.bet)
		winner.add_amount(-1 * winner.bet + pot)
				
		loser.game_end(winner.strategy_id, pot, message)
		winner.game_end(winner.strategy_id, pot, message)
	end
end
