require_relative '../lib/n_queens'

def score(board)
  board.valid? ? board.placed : -1
end

def solve(board)
  if board.complete?
    puts "Found solution: PASS"
    puts board
    return
  end

  orig_score = score(board)
  candidates = board.available_spaces.shuffle

  improvement = candidates.find do |candidate|
    new_board = board.place(candidate[:x], candidate[:y])
    new_score = score(new_board)

    new_score > orig_score
  end

  unless improvement
    puts "No local improvement found! FAIL"
    puts board
    puts board.inspect
    return
  end

  solve(board.place(improvement[:x], improvement[:y]))
end

solve(ChessBoard.new(6))
