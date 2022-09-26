require_relative "Strategy"
require_relative "Order"
require_relative "Player"

# 2�� Strategy ���Ǘ����� match ��i�s����N���X
class Dealer

	AMOUNT = 100
	N_GAMES = 1000
	ANTE = 1
	HANDS = [0, 1, 2]

	# match ��i�s����
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

	# game �̏������s��
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
	
	# turn �̏������s��
	def make_turn(current, opponent, turn, pot_ante)
		action = current.action(turn)

		# action ���e���`�F�b�N���A���[���ᔽ������� message �ɐݒ肷��
		message = check_action(action, current, opponent)

		if message
			# �ᔽ������̂Ō��݂� player �𕉂��Ƃ���
			end_game(opponent, current, pot_ante, message)
			return false
		elsif action < 0
			message = "fold by #{current.strategy_id}"
			end_game(opponent, current, pot_ante, message)
			return false
		end

		# fold �ł͂Ȃ��L���� bet �ł��邽�߁Abet�z��ێ����Ă���
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



	# current �̒�o���� action �̓��e���Ó����`�F�b�N����
	#
	# @param [Integer] action action
	# @param [Player] current ��ԃv���C���[
	# @param [Player] opponent ���ԃv���C���[
	# @return [String] nil: ���[���Ɉᔽ���Ă��Ȃ� message: ���[���ᔽ�̏ڍ�
	def check_action(action, current, opponent)
		minimum_raise = opponent.bet + (opponent.bet - current.bet)

		if action < 0
			# fold -> OK
			nil
		elsif action == current.amount
			# all in -> OK
			nil
		elsif action > current.amount
			# ���݂ۗ̕L�|�C���g���傫�� bet -> NG
			"fold by #{current.strategy_id} reason: invalid bet. current bet = #{action}, amount = #{current.amount} opponent bet = #{opponent.amount}"
		elsif action < opponent.bet
			# (all in �ł͂Ȃ�)����� bet �z��菬���� bet -> NG
			"fold by #{current.strategy_id} reason: invalid bet. current bet = #{action}, amount = #{current.amount} opponent bet = #{opponent.amount}"
		elsif action == opponent.bet
			# call or check -> OK
			nil
		elsif action < minimum_raise
			# raise �z�ɖ����Ȃ� bet -> NG
			"fold by #{current.strategy_id} reason: less than minimum raise.  current bet = #{action}, amount = #{current.amount} opponent bet = #{order.opponent.amount} minimum raise = #{minimum_raise}"
		else
			# raise -> OK
			nil
		end
	end

	# showdown �̏������s��
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

	# game �̏I���������s��
	def end_game(winner, loser, pot_ante, message)
		pot = winner.bet + loser.bet + pot_ante
		loser.add_amount(-1 * loser.bet)
		winner.add_amount(-1 * winner.bet + pot)
				
		loser.game_end(winner.strategy_id, pot, message)
		winner.game_end(winner.strategy_id, pot, message)
	end
end
