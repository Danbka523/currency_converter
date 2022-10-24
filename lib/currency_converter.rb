# frozen_string_literal: true

require_relative "currency_converter/version"
require "nokogiri"
require "open-uri"
require "benchmark"
$address7 = 'https://cbr.ru/scripts/XML_News.asp'
$address8 = 'https://cbr.ru/scripts/XML_bic.asp?'
$address9 = 'https://cbr.ru/scripts/xml_swap.asp?'

module CurrencyConverter
  class Error < StandardError; end
  def news_ex_7()
    doc7 = Nokogiri::XML(URI.open($address7))
    root7 = doc7.root
    root7.children.each do |child|
    p "Item ID = "+child.attr('ID')+" Дата: "+child.children[0].content
    p "URL: "+child.children[1].content
    p "Название: "+child.children[2].content
    p "————————————————————————"
    end
  end

  def bic_ex8()
    doc8 = Nokogiri::XML(URI.open($address8))
    root8 = doc8.root
    root8.children.each do |child|
      p "Record ID = "+child.attr('ID')
      p "Дата: "+child.attr('DU')
      p "Название: "+child.first_element_child.content
      p "BIC(код кредитной орагнизации):"+child.last_element_child.content
      p "————————————————————————"
    end
  end

  def currency_swap_ex9(date_req19,date_req29)
    #if(!(validate_date(date_req19) && validate_date(date_req29)))
    # throw Error
    #end
    doc9 = Nokogiri::XML(URI.open($address9+"date_req1="+date_req19+"&"+"date_req2="+date_req29))
    root9 = doc9.root
    root9.children.each do |child|
      p "IsEuro = "+child.attr('IsEuro')
      p "Дата покупки: "+child.children[0].content
      p "Дата продажи: "+child.children[1].content
      p child.children[2].content
      p child.children[3].content
      p child.children[4].content
      p child.children[5].content
      p "————————————————————————"
    end
  end

end

include CurrencyConverter
#news_ex_7()
#bic_ex8()
#currency_swap_ex9("01/12/2002","06/12/2002")
