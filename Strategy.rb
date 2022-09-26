# �ʂ̐헪�� Strategy class �̃T�u�N���X�Ƃ��Ē�`����
class Strategy

	# �^�c���犄�蓖�Ă�ꂽ�헪����ӂɌ��߂� ID ��Ԃ�
	#
	# @return [Integer] id
	def get_id()
		throw NotImplementedError.new
	end
	
	# �헪�̖��O��Ԃ�
	#
	# @return [String] ���O
	def get_name()
		self.class.name
	end

	# �헪�S�̂��������������L�q����B�ŏ��Ɉ�x�̂݌Ă΂��B
	# ���ꂪ�Ă΂�Ă��畡����� match ����������B(����ɂ͔������� match ���ɏI�����Ă��玟�� match ���J�n�����)
	def strategy_initialize()
	end
	
	# �헪�S�̂̏I���������L�q����B
	# �ʏ�� match_end() ���Ă΂�Ă��炱�ꂪ�Ă΂�邪�A���炩�̃G���[�������ȂǏ�ɂ��ꂪ�Ă΂�ďI������\��������B
	def strategy_terminate()
	end

	# match �̊J�n���ɌĂ΂��B
	# match �͓���̑ΐ�҂Ƃ̈�A�̎����ł���A������ game ���܂܂��B
	# ����̃|�C���g�� 0 �ɂȂ邩�A�w�肳�ꂽ�񐔂� game ���I���������� match �͏I������B
	# 
	# @param [Integer] opponent_id �ΐ�҂�id
	# @param [Integer] amount �o���̏����|�C���g
	# @param [Integer] ante �A���e�B
	# @param [Integer] n_games game �̍ő�񐔂��n�����B
	def match_start(opponent_id, amount, ante, n_games)
	end

	# match �̏I�����ɌĂ΂��B
	# �I�����̎����̃|�C���g����ёΐ�҂̃|�C���g���ʒm�����B
	#
	# @param [Integer] amount �I�����̃|�C���g
	# @param [Integer] amount_opponent �I�����̑ΐ�҂̃|�C���g
	def match_end(amount, amount_opponent)
	end

	# game �̊J�n���ɌĂ΂��B
	# game �� ante ���x�����J�[�h���z���ď��������܂ł̈�̃Q�[���ł���A������ action ���܂܂��B
	# ��s����U���͖������ւ��B
	# 
	# @param [Integer] amount game �J�n���� ante �x������̃|�C���g
	# @param [Integer] amount_opponent game �J�n���� ante �x������̑ΐ�҂̃|�C���g
	# @param [Integer] order ��s or ��U�B1: ��s 2: ��U
	# @param [Integer] pot_ante ante �̍��v�z
	# @param [Integer] hand �z��ꂽ�J�[�h�B 2: A 1: K 0: Q
	def game_start(amount, amount_opponent, order, pot_ante, hand)
	end

	# game �̏I�����ɌĂ΂��B
	# ��{�I�ɂ� action() ���Ă΂ꂽ��ɌĂ΂�邪�A��s�� fold �����ꍇ�̌��� game_start() �̎��ɂ��ꂪ�Ă΂��B
	# 
	# @param [Integer] amount game �I�����̃|�C���g
	# @param [Integer] amount_opponent game �I�����̑ΐ�҂̃|�C���g
	# @param [Integer] winner_id game �ɏ������� Strrategy �� id
	# @param [String] message game �̏I���Ɋւ���ڍׁB�e�탋�[���ᔽ������ꍇ�����̎|�̓��e���n�����
	def game_end(amount, amount_opponent, winner_id, pot, message)
	end

	# game ���̎�ԂŌĂ΂��B
	# ������ action ��Ԃ��K�v������B
	# 
	# @param [Integer] turn 1�ȏ�̒l�B��s�͊�A��U�͋����݂̂��n�����
	# @param [Integer] bet ����܂łɎ������錾�����|�C���g�Bturn = 1 or 2 �̏ꍇ�� 0 ���n�����
	# @param [Integer] bet_opponent ����܂łɑΐ�҂��錾�����|�C���g�Bturn = 1 �̏ꍇ�� 0 ���n�����
	# @return [Integer] fold ����ꍇ�͕����Bcall ����ꍇ�� bet_opponent �̒l�Braise ����ꍇ�͏����𖞂����l�Ball in ����ꍇ�͎����� amount �̒l�B
	def action(turn, bet, bet_opponent) 
		throw NotImplementedError.new
	end
end
