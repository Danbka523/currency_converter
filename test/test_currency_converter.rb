# frozen_string_literal: true

require "test_helper"
require "currency_converter"
class TestCurrencyConverter < Minitest::Test

  include CurrencyConverter

  def test_that_it_has_a_version_number
    refute_nil ::CurrencyConverter::VERSION
  end

  def test_get_code
    assert_equal "R01235",get_code("доллар сша")
    assert_equal "",get_code("abracadabra")
  end

  def test_get_daily_cur
    assert_throws (CurrencyConverter::InvalidDate){get_daily_cur("2222/02/11","")}
    assert_throws (CurrencyConverter::InvalidCurrency){get_daily_cur("21/12/2022","lool")}
  end

  def test_get_dynamic
    assert_throws (CurrencyConverter::InvalidDate){get_dynamic_cur("2222/02/11","1221321312","доллар сша")}
    assert_throws (CurrencyConverter::InvalidCurrency){get_dynamic_cur("21/12/2022","21/12/2002","aaa")}
  end

  def test_get_reamins
    assert_throws (CurrencyConverter::InvalidDate){get_remains("2222/02/11","1221321312")}
  end

end
