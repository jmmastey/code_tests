# N Queens problem:
# Given a normal 8x8 chess board, how can you place 8 queens on that board such
# that none of them can hit any others in one move. Should also work on other
# board sizes, which lets us change the amount of work necessary to compute a
# solution.
class ChessBoard
  def initialize(board_size, queens = [])
    @board_size = board_size
    @queens     = queens
  end

  def place(x, y)
    raise ArgumentError unless valid_space?(x, y)

    new_queens = @queens.clone
    new_queens << { x: x, y: y }
    self.class.new(@board_size, new_queens)
  end

  def valid?
    @queens.all? do |candidate|
      others = @queens - [candidate]
      others.none? { |q| intersects?(candidate, q) }
    end
  end

  def complete?
    valid? && placed == @board_size
  end

  def placed
    @queens.length
  end

  def available_spaces
    all_spaces = []
    1.upto(@board_size) do |x|
      1.upto(@board_size) do |y|
        candidate = { x: x, y: y }
        all_spaces << candidate unless @queens.include?(candidate)
      end
    end

    all_spaces
  end

  def to_s
    board = Array.new(@board_size) { Array.new(@board_size, "-") }
    @queens.each { |q| board[q[:y] - 1][q[:x] - 1] = "Q" }

    str = " " + ("-" * (@board_size * 4)) + "-\n"
    board.each do |row|
      row.each do |cell|
        str += " | #{cell}"
      end
      str += " |\n"
      str += " " + ("-" * (@board_size * 4)) + "-\n"
    end
    str
  end

  def inspect
    "#<#{self.class} placed=#{placed} valid?=#{self.valid?} complete?=#{self.complete?}>"
  end

  private

  def intersects?(queen1, queen2)
    queen1[:x] == queen2[:x] ||
      queen1[:y] == queen2[:y] ||
      diagonal_spaces(queen2).include?(queen1)
  end

  def diagonal_spaces(queen)
    [queen].tap do |diagonals|
      1.upto(@board_size) do |offset|
        diagonals << { x: queen[:x] + offset, y: queen[:y] + offset }
        diagonals << { x: queen[:x] - offset, y: queen[:y] + offset }
        diagonals << { x: queen[:x] + offset, y: queen[:y] - offset }
        diagonals << { x: queen[:x] - offset, y: queen[:y] - offset }
      end
    end.select do |space|
      valid_space?(space[:x], space[:y])
    end
  end

  def valid_space?(x, y)
    x.between?(1, @board_size) && y.between?(1, @board_size)
  end
end

# cb = ChessBoard.new(4)
# cb.place(2, 1)
# cb.place(1, 3)
# cb.place(4, 2)
# cb.place(3, 4)
# puts cb
# puts cb.inspect
