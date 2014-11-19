require 'watir-webdriver'
require 'dotenv'
Dotenv.load

require_relative '../models/init'

browser = Watir::Browser.new
browser.goto 'http://www.knesset.gov.il/lobbyist/heb/lobbyist.aspx'

browser.links(:xpath, '//a[@lobbyist_id]')[0..1].map(&:id).each do |id|
  link = browser.link(id: id)
  link.click
  # puts link.attribute_value 'id'
  lobbyist_web_id = link.attribute_value 'lobbyist_id'
  Watir::Wait.until { browser.text.include? 'פרטי השדלן:' }  

  spans = browser.spans(:class => 'text3')
  lobbyist_name = spans[0].text
  lobbying_company_name = spans[1].text
  lobbying_company_corp_id = spans[2].text
  company_names = spans[4..spans.size - 1].map{|span| span.text}

  lobbying_company = LobbyingCompany.find_or_create(:name => lobbying_company_name)
  lobbying_company.update(:corp_id => lobbying_company_corp_id) unless lobbying_company_corp_id.nil? || lobbying_company_corp_id.empty?

  lobbyist = Lobbyist.find_or_create(:name => lobbyist_name, :lobbying_company_id => lobbying_company.id)
  lobbyist.update(:web_id => lobbyist_web_id) unless lobbyist_web_id.nil? || lobbyist_web_id.empty?

  company_names.each do |company_name|
    company = Company.find_or_create(:name => company_name)
    DB.run "INSERT INTO companies_lobbyists VALUES(default, #{company.id}, #{lobbyist.id}, NOW(), NOW())" 
  end

  puts "Name #{lobbyist_name}"
  puts "Company #{lobbying_company_name}"
  company_names.each{|c| puts "Lobbying for: #{c}" }
  puts
  puts  
end

browser.close