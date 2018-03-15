class Password
  require 'securerandom'

  CHAR_LIST = 'abcdefghijklmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ123456789'.chars.freeze    # omit o,O,0
  SYMBOL_LIST = '._-=[]{}+#^!?'.chars.freeze

  def self.generate(symbol: false, length: 8)
    self.new.generate(symbol, length)
  end

  def generate(symbol, len)
    raise 'too short' if len < 4
    raise 'too long'  if len > 32

    @symbol_use = symbol
    loop do
      password = len.times.map { |n| pick_one(len, n) }.join
      return password if check(password)
    end
  end

  private

  def pick_one(len, n)
    char_list = usable_symbol?(len, n) ? CHAR_LIST + SYMBOL_LIST : CHAR_LIST
    random_index = (SecureRandom.random_number(1.0) * char_list.size).floor
    char_list[random_index]
  end

  def usable_symbol?(len, n)
    @symbol_use && n.between?(1, len - 2)
  end

  def check(str)
    # omit successive chars
    return false if /(.)\1\1/ =~ str

    # confirm the str contains 1..2 symbols
    @symbol_use ? satisfy_symbol_count?(str) : true
  end

  def satisfy_symbol_count?(str)
    [1, 2].include?(count_symbol(str))
  end

  def count_symbol(str)
    str.scan(Regexp.union(SYMBOL_LIST)).size
  end

end
