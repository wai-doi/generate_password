require 'minitest/autorun'
require_relative '../lib/generate_password'

class TestGeneratePassword < Minitest::Test
  SYMBOL_LIST = '._-=[]{}+#^!?'.chars.freeze
  def setup
    @password = Password.generate(length: 16)
    @symbol_password = Password.generate(symbol: true, length: 16)
  end

  # 長さが32文字以下
  def test_length_limit
    assert @password.length <= 32
    assert @symbol_password.length <= 32
  end

  # 0, o, 0は使わない
  def test_unuse_zero_and_o
    refute @password =~ /0|o|O/
    refute @symbol_password =~ /0|o|O/
  end

  # 3文字以上連続しない
  def test_sequence
    refute @password =~ /(.)\1{2,}/
    refute @symbol_password =~ /(.)\1{2,}/
  end

  # オプションをつけた場合には1、2こ記号を使う
  def test_use_symbol
    symbol_count = @symbol_password.scan(Regexp.union(SYMBOL_LIST)).size
    assert [1, 2].include?(symbol_count)
  end

  # 最初と最後の文字には記号は使わない
  def test_unuse_symbol_at_head_and_tail
    refute @symbol_password[0] =~ Regexp.union(SYMBOL_LIST)
    refute @symbol_password[-1] =~ Regexp.union(SYMBOL_LIST)
  end
end
