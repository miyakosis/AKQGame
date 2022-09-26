# 個別の戦略は Strategy class のサブクラスとして定義する
class Strategy

	# 運営から割り当てられた戦略を一意に決める ID を返す
	#
	# @return [Integer] id
	def get_id()
		throw NotImplementedError.new
	end
	
	# 戦略の名前を返す
	#
	# @return [String] 名前
	def get_name()
		self.class.name
	end

	# 戦略全体を初期化処理を記述する。最初に一度のみ呼ばれる。
	# これが呼ばれてから複数回の match が発生する。(並列には発生せず match 毎に終了してから次の match が開始される)
	def strategy_initialize()
	end
	
	# 戦略全体の終了処理を記述する。
	# 通常は match_end() が呼ばれてからこれが呼ばれるが、何らかのエラー発生時など常にこれが呼ばれて終了する可能性がある。
	def strategy_terminate()
	end

	# match の開始時に呼ばれる。
	# match は特定の対戦者との一連の試合であり、複数の game が含まれる。
	# 一方のポイントが 0 になるか、指定された回数の game が終了した時に match は終了する。
	# 
	# @param [Integer] opponent_id 対戦者のid
	# @param [Integer] amount 双方の初期ポイント
	# @param [Integer] ante アンティ
	# @param [Integer] n_games game の最大回数が渡される。
	def match_start(opponent_id, amount, ante, n_games)
	end

	# match の終了時に呼ばれる。
	# 終了時の自分のポイントおよび対戦者のポイントが通知される。
	#
	# @param [Integer] amount 終了時のポイント
	# @param [Integer] amount_opponent 終了時の対戦者のポイント
	def match_end(amount, amount_opponent)
	end

	# game の開始時に呼ばれる。
	# game は ante を支払いカードが配られて勝負がつくまでの一つのゲームであり、複数の action が含まれる。
	# 先行か後攻かは毎回入れ替わる。
	# 
	# @param [Integer] amount game 開始時の ante 支払い後のポイント
	# @param [Integer] amount_opponent game 開始時の ante 支払い後の対戦者のポイント
	# @param [Integer] order 先行 or 後攻。1: 先行 2: 後攻
	# @param [Integer] pot_ante ante の合計額
	# @param [Integer] hand 配られたカード。 2: A 1: K 0: Q
	def game_start(amount, amount_opponent, order, pot_ante, hand)
	end

	# game の終了時に呼ばれる。
	# 基本的には action() が呼ばれた後に呼ばれるが、先行が fold した場合の後手は game_start() の次にこれが呼ばれる。
	# 
	# @param [Integer] amount game 終了時のポイント
	# @param [Integer] amount_opponent game 終了時の対戦者のポイント
	# @param [Integer] winner_id game に勝利した Strrategy の id
	# @param [String] message game の終了に関する詳細。各種ルール違反がある場合もその旨の内容が渡される
	def game_end(amount, amount_opponent, winner_id, pot, message)
	end

	# game 中の手番で呼ばれる。
	# 自分の action を返す必要がある。
	# 
	# @param [Integer] turn 1以上の値。先行は奇数、後攻は偶数のみが渡される
	# @param [Integer] bet それまでに自分が宣言したポイント。turn = 1 or 2 の場合は 0 が渡される
	# @param [Integer] bet_opponent それまでに対戦者が宣言したポイント。turn = 1 の場合は 0 が渡される
	# @return [Integer] fold する場合は負数。call する場合は bet_opponent の値。raise する場合は条件を満たす値。all in する場合は自分の amount の値。
	def action(turn, bet, bet_opponent) 
		throw NotImplementedError.new
	end
end
