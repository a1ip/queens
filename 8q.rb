#!/home/phil/.rvm/rubies/ruby-1.9.2-head/bin/ruby
#
# This is a pretty straight translation of Timothy Budd's Objective C 8 queens
# solution presented in Appendix A of the first edition of "An Introduction To
# Object-Oriented Programming" published by Addison-Wesley (ISBN 0 201 54709
# 0)
#
# It is an experiment in Ruby to see how easily a perl-er can pick it up.
#
###############################################################################

SIZE = 8

# Queen
#
# the class which does most of the work

class Queen

  # initialColumn
  #
  # initialise the column and neighbour values

  def initialColumn(column, neighbour)
    @column = column
    @neighbour = neighbour
    nil
  end

  # canAttack?
  #
  # returns true if this queen or any of her neighbours can attack a
  # given position, false if not

  def canAttack?(row, column)
    return true if row == @row

    cd = (column - @column).abs
    rd = (row - @row).abs
    return true if cd == rd

    @neighbour.canAttack?(row, column)
  end

  # testOrAdvance?
  #
  # see if this queen's current position can ba attacked.  return true
  # if it's a safe position, or try and the next position and test it.
  # return false if we're at wit's end

  def testOrAdvance?
    if @neighbour.canAttack?(@row, @column)
      return next?
    end

    return true
  end

  # first?
  #
  # set up an initial acceptable position for this queen and neighbours.
  # return true if it's possible to set up, false if not.

  def first?
    @row = 1

    return testOrAdvance? if @neighbour.first?

    return false
  end

  # next?
  #
  # tries to move this queen to the next safe position, returns true if it's
  # possible or false if not

  def next?
    if @row == SIZE
      return false unless @neighbour.next?
      @row = 0
    end

    @row += 1

    testOrAdvance?
  end

  # getState
  #
  # collect the current state of my neighbours and add my own before 
  # returning an array of row/column arrays

  def getState
    stateArray = @neighbour.getState
    stateArray << [@row, @column]
  end

end

# NullQueen
#
# a class of queen used to indicate the end of the set of queens

class NullQueen < Queen

  def canAttack?(row, column)
    false
  end

  def first?
    true
  end

  def next?
    false
  end

  def getState
    Array.new
  end

end

# the program

neighbour = NullQueen.new
lastQueen = nil

1.upto(SIZE) { |column|
  lastQueen = Queen.new
  lastQueen.initialColumn(column, neighbour)
  neighbour = lastQueen
}

if lastQueen.first?
  lastQueen.getState.each { |state|
    puts "row: #{state[0]} column: #{state[1]}"
  }
end
