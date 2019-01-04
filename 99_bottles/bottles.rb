# frozen_string_literal: true

class Bottles
  def song
    verses(99, 0)
  end

  def verses(start, stop)
    verses = start.downto(stop).map { |num| verse(num) }
    verses.join("\n")
  end

  def verse(num)
    case num
    when 0 then start_over_verse
    when 1 then run_out_verse(num)
    else        basic_verse(num)
    end
  end

  private

  def basic_verse(num)
    "#{num} #{container(num)} on the wall, #{num} #{container(num)}.\n" \
    'Take one down and pass it around, ' \
    "#{num - 1} #{container(num - 1)} on the wall.\n"
  end

  def run_out_verse(num)
    "#{num} #{container(num)} on the wall, #{num} #{container(num)}.\n" \
    'Take it down and pass it around, ' \
    "no more #{container(0)} on the wall.\n"
  end

  def start_over_verse
    "No more #{container(0)} on the wall, no more #{container(0)}.\n" \
    'Go to the store and buy some more, ' \
    "99 #{container(99)} on the wall.\n"
  end

  def container(num)
    case num
    when 1 then 'bottle of beer'
    when 6 then 'six-pack of beer'
    else        'bottles of beer'
    end
  end
end
