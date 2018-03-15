class Password
  require 'securerandom'

  CHAR_LIST = 'abcdefghijklmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ123456789'.chars.freeze    # omit o,O,0
  SYMBOL_LIST = '._-=[]{}+#^!?'.chars.freeze

  def initialize(symbol: false)
    @symbol = symbol
  end

  def generate(len = 8)
    raise 'too short' if len < 4
    raise 'too long'  if len > 32

    loop do
      result = len.times.map { |n| pick_one(len, n) }.join
      return result if check(result)
    end
  end

  private

  def pick_one(len, n)
    char_list = usable_symbol?(len, n) ? CHAR_LIST : CHAR_LIST + SYMBOL_LIST
    random_index = (SecureRandom.random_number(1.0) * char_list.size).floor
    char_list[random_index]
  end

  def usable_symbol?(len, n)
    !@symbol || (n.zero? || n == len - 1)
  end

  def check(str)
    # omit successive chars
    return false if /(.)\1\1/ =~ str

    # confirm the str contains 1..2 symbols
    if @symbol
      return false unless [1, 2].include?(count_symbol(str))
    end
    true
  end

  def count_symbol(str)
    str.scan(Regexp.union(SYMBOL_LIST)).size
  end

end
