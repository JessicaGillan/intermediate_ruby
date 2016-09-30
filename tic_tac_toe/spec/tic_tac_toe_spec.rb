require 'lib/tic_tac_toe'

describe TicTacToe do 
	let(:tictactoe) { TicTacToe.new }

	# before(:each) do
	# 	allow(tictactoe).to receive(:print)
	# 	allow(tictactoe).to receive(:puts)
	# end

	describe '#play' do

		context 'three in a row' do
			it 'recognizes horizontal win' do
				allow(tictactoe).to receive(:get_valid_choice).and_return(1,4,2,5,3)

				expect(tictactoe).to receive(:game_over?).and_call_original.exactly(6).times
				expect(tictactoe).to receive(:puts).with("One WON!")

				tictactoe.play
			end
		end

		# context 'three in a column' do
		# 	it 'recognizes vertical win' do
		# 	end
		# end

		# contect 'three in a diagonal' do 
		# 	it 'recognizes diagonal win' do
		# 	end
		# end
	end

	# describe '.play_again?' do
	# end
end