WINNING_POSITIONS = [
  '111000000', '000111000', '000000111',
  '100100100', '010010010', '001001001',
  '100010001', '001010100',
].map { |s| s.to_i(2) }

board   = '123456789'
playerX = { mark: 'X', name: 'Player X', position: '000000000' }
playerO = { mark: 'O', name: 'Player O', position: '000000000' }

players = [playerX, playerO].cycle
previousPlayer = playerO

def print_board(board, cols: 3)
  puts "-" * (cols * 3)
  board.chars.each_slice(cols) do |row|
    puts row.join(" | ")
    puts "-" * (cols * 3)
  end
end

def wins?(position)
  mask = position.to_i(2)

  WINNING_POSITIONS.any? do |winning_mask|
    (mask & winning_mask) == winning_mask
  end
end

while true do
  print_board(board)
  current_player = players.next
  puts "Input move for #{current_player[:name]}"
  move = gets.chomp.to_i - 1

  board[move] = current_player[:mark]
  current_player[:position][move] = '1'

  if wins?(current_player[:position])
    puts "\n\n#{current_player[:name]} wins! Final board:"
    print_board(board)
    exit
  end
end


