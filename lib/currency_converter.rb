# frozen_string_literal: false

require 'open-uri'
require 'nokogiri'
require_relative "currency_converter/version"

$daily_req='http://www.cbr.ru/scripts/XML_daily.asp?date_req='
$dynamic_cur_req="http://www.cbr.ru/scripts/XML_dynamic.asp?"
$cur_code_req='https://cbr.ru/scripts/XML_val.asp?d=0'
$rem_req="http://www.cbr.ru/scripts/XML_ostat.asp?"
$news_req = 'https://cbr.ru/scripts/XML_News.asp'
$bic_req = 'https://cbr.ru/scripts/XML_bic.asp?'
$currencyswap_req = 'https://cbr.ru/scripts/xml_swap.asp?'
$coinsbase_req = 'https://cbr.ru/scripts/XMLCoinsBase.asp?'

using Nokogiri
module CurrencyConverter

  class InvalidDate < StandardError; end
  class InvalidCurrency < StandardError; end


  def get_daily_cur(date="",currency="")

    code=get_code(currency)
    throw InvalidCurrency if code==''

    doc=Nokogiri::XML(URI.open($daily_req+date))
    #res=''
    root=doc.root

    throw InvalidDate if root.children.text=="Error in parameters"

    root.children.each do |child|
      p child.xpath('Name').text+' '+child.xpath("Nominal").text+' '+child.xpath("Value").text+';'
    end
    #p res
    #res
  end

  def get_dynamic_cur(date1,date2,currency)

    code=get_code(currency)
    throw InvalidCurrency if code==''

    req=$dynamic_cur_req+"date_req1="+date1+"&date_req2="+date2+"&VAL_NM_RQ="+code
    doc=Nokogiri::XML(URI.open(req))
    #res=''
    root=doc.root

    throw InvalidDate if root.children.text=="Error in parameters"

    root.children.each do |child|
      p child.attribute('Date').value+' '+child.xpath("Nominal").text+' '+child.xpath("Value").text+";"
    end
   # p res
   # res
  end

  def get_code(currency)
    temp=currency.downcase
    res=''
    doc=Nokogiri::XML(URI.open($cur_code_req))
    root=doc.root
    root.children.each do |child|
      res=child.attribute('ID').value if child.xpath('Name').text.downcase==temp
    end
    res
  end

  def get_remains(date1, date2)
    req=$dynamic_cur_req+"date_req1="+date1+"&date_req2="+date2
    doc=Nokogiri::XML(URI.open(req))
    #res=''
    root=doc.root

    throw InvalidDate if root.children.text=="Error in parameters"
    p root
    root.children.each do |child|
      p child.attribute('Date').value+' '+child.xpath("InRussia").text+' '+child.xpath("InMoscow").text+";"
    end
  end

  def news()
    doc7 = Nokogiri::XML(URI.open($news_req))
    root7 = doc7.root
    throw InvalidDate if root7.children.text=="Error in parameters"
    root7.children.each do |child|
    p "Item ID = "+child.attr('ID')+" Date: "+child.children[0].content
    p "URL: "+child.children[1].content
    p "Name: "+child.children[2].content
    p "————————————————————————"
    end
  end

  def bic()
    doc8 = Nokogiri::XML(URI.open($bic_req))
    root8 = doc8.root
    throw InvalidDate if root8.children.text=="Error in parameters"
    root8.children.each do |child|
      p "Record ID = "+child.attr('ID')
      p "Date: "+child.attr('DU')
      p "Name: "+child.first_element_child.content
      p "BIC(credit institution code):"+child.last_element_child.content
      p "————————————————————————"
    end
  end

  def currency_swap(date_req19,date_req29)
    #if(!(validate_date(date_req19) && validate_date(date_req29)))
    # throw Error
    #end
    doc9 = Nokogiri::XML(URI.open($currencyswap_req+"date_req1="+date_req19+"&"+"date_req2="+date_req29))
    root9 = doc9.root
    throw InvalidDate if root9.children.text=="Error in parameters"
    root9.children.each do |child|
      p "IsEuro = "+child.attr('IsEuro')
      p "Buy date: "+child.children[0].content
      p "Sell date: "+child.children[1].content
      p child.children[2].content
      p child.children[3].content
      p child.children[4].content
      p child.children[5].content
      p "————————————————————————"
    end
  end

  def coinsbase(date_req110, date_req210)
    #if(!(validate_date(date_req110) && validate_date(date_req210)))
    # throw Error
    #end
    doc10 = Nokogiri::XML(URI.open($coinsbase_req+"date_req1="+date_req110+"&"+"date_req2="+date_req210))
    root10 = doc10.root
    throw InvalidDate if root10.children.text=="Error in parameters"
    root10.children.each do |child|
      p "CoinsID = "+child.attr('CoinsID')
      p "Date: "+child.children[0].content
      p "Price: "+child.children[1].content
      p "Nominal: "+child.children[2].content
      p "Metall: "+child.children[3].content
      p child.children[4].content
      p "————————————————————————"
    end
  end

end

include CurrencyConverter
#news()
#bic()
#currency_swap("01/12/2006","01/12/2008")
#coinsbase("01/12/2005","01/12/2006")
#get_remains("01/06/2001","05/06/2001")
