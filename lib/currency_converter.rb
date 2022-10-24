# frozen_string_literal: false

require 'open-uri'
require 'nokogiri'
require_relative "currency_converter/version"

$daily_req='http://www.cbr.ru/scripts/XML_daily.asp?date_req='
$dynamic_cur_req="http://www.cbr.ru/scripts/XML_dynamic.asp?"
$cur_code_req='https://cbr.ru/scripts/XML_val.asp?d=0'
$rem_req="http://www.cbr.ru/scripts/XML_ostat.asp?"

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

end

include CurrencyConverter
get_remains("01/06/2001","05/06/2001")