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
$metal_req = 'https://cbr.ru/scripts/xml_metall.asp?'
$deposit_rates = 'https://cbr.ru/scripts/xml_depo.asp?'
$credit_req = 'https://cbr.ru/scripts/xml_mkr.asp?'

using Nokogiri
module CurrencyConverter

  class InvalidDate < StandardError; end
  class InvalidCurrency < StandardError; end
  class InvalidMetal < StandardError; end


  def get_daily_cur(date="",currency="")
    code=""
    if currency!=""
     code=get_code(currency)
     throw InvalidCurrency if code==''
    end

    doc=Nokogiri::XML(URI.open($daily_req+date))
    res=''
    root=doc.root

    throw InvalidDate if root.children.text=="\nError in parameters\n"


    if currency!=""
      root.children.each do |child|
        if child.attribute("ID").value==code
          value=child.xpath('Name').text+';'+child.xpath("Nominal").text+';'+child.xpath("Value").text+';'
          p value
           res+=value
           res
        end
      end
    else
     root.children.each do |child|
        value=child.xpath('Name').text+';'+child.xpath("Nominal").text+';'+child.xpath("Value").text+';'
        p value
        res+=value
     end
    end
    res
  end

  def get_dynamic_cur(date1,date2,currency)

    code=get_code(currency)
    throw InvalidCurrency if code==''

    req=$dynamic_cur_req+"date_req1="+date1+"&date_req2="+date2+"&VAL_NM_RQ="+code
    doc=Nokogiri::XML(URI.open(req))
    res=''
    root=doc.root

    throw InvalidDate if root.children.text=="Error in parameters"

    root.children.each do |child|
      value=child.attribute('Date').value+';'+child.xpath("Nominal").text+';'+child.xpath("Value").text+";"
      res+=value
      p value
    end

    res
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
    res=''
    root=doc.root

    throw InvalidDate if root.children.text=="Error in parameters"

    root.children.each do |child|
      value=child.attribute('Date').value+' '+child.xpath("InRussia").text+' '+child.xpath("InMoscow").text+";"
      p value
      res+=value
    end
    res
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
    doc9 = Nokogiri::XML(URI.open($currencyswap_req+"date_req1="+date_req19+"&"+"date_req2="+date_req29))
    root9 = doc9.root
    throw InvalidDate if root9.children.text==""
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

  def get_metal_info(date_req1,date_req2,name_of_metal="")
    code_metal = codes_of_metals(name_of_metal.downcase)
    root = Nokogiri::XML(URI.open($metal_req+"date_req1="+date_req1+"&"+"date_req2="+date_req2)).root
    throw InvalidDate if root.children.text=="Error in date format" || root.attribute('ToDate').value==''
    root.children.each do |child|
   if  code_metal==nil || child.attribute('Code').value==code_metal
       puts "\n"+child.attribute('Date').value + " Code = " + child.attribute('Code').value
      puts "BUY:"+child.first_element_child.content + " RUB\n" + "SELL:"+child.last_element_child.content + " RUB\n"
    end
   end
  end

  def codes_of_metals(name_of_metal)
   if name_of_metal.empty?
    return nil
   end
   hash= {"gold"=>"1","silver"=>"2","platinum"=>"3","palladium"=>"4"}
   if  hash.key?(name_of_metal)
    return hash[name_of_metal]
   end
   throw InvalidMetal
  end

  def get_deposit_rates(date_req1,date_req2)
    root = Nokogiri::XML(URI.open($deposit_rates+"date_req1="+date_req1+"&"+"date_req2="+date_req2)).root
    throw InvalidDate if root.children.text=="Error in parameters"
    root.children.each do |child|
    puts "\n" + child.attribute('Date').value + "\n"
    child.children.each do  |el|
    puts el.name + ": " + el.text+"%"
      end
    end
  end

  def get_credit_market_info(date_req1,date_req2)
    root = Nokogiri::XML(URI.open($credit_req+"date_req1="+date_req1+"&"+"date_req2="+date_req2)).root
    throw InvalidDate if root.children.text=="DataNotFound"
    root.children.each do |child|
      puts "Date: "+child.attribute('Date').value+" Code: "+child.attribute('Code').content
      puts "1 day: "+ child.children[0].content
      puts "2 to 7 days: "+ child.children[1].content
      puts "8 to 30 days: "+ child.children[2].content
      puts "31 to 90 days: "+ child.children[3].content
      puts "91 to 180 days: "+ child.children[4].content
      puts "181 to 1 year: "+ child.children[5].content
      puts "(in percentage per annum)"
    end
  end

end

include CurrencyConverter

#news()
#bic()
#coinsbase("10/05/2005","11/06/2006")
#currency_swap("10/11/2010","08/05/2011")
#get_deposit_rates("15/08/2015","16/09/2018")
#get_credit_market_info("15/08/2015","16/09/2018")
