require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'fileutils'

def weblist(companyname,webpage,filename)
  begin
    fileArr = []
    file = "#{companyname}"
    page = Nokogiri::HTML(open(webpage, 'User-Agent' => 'firefox'))
    action = page.css('div.action a.action-email')

    action.each do |link|
        email = link['href']
        email = email.gsub('#','')
        formatEmail = email.gsub('mailto:','')
        file = "#{companyname},#{formatEmail}"
    end

    fileArr << file

    File.open("#{filename}.csv","a+") { |f|
      f.puts(fileArr)
     }
 rescue => error
   puts ">> Unable to get email from #{companyname} << | ERROR: #{error}"
 end
end

def checkFileIfExist(filename)
  if File.exist? "#{filename}.csv"
    FileUtils.rm("#{filename}.csv")
  end
end

def searchByArea(area,lookfor)
  puts "=============================================== Filter Area: #{area} "
  area = area.downcase
  area = area.gsub(' ','+')

  if area.empty?
    webcontent = Nokogiri::HTML(open("https://yellow.co.nz/auckland-region/#{lookfor}", 'User-Agent' => 'firefox'))
  else
    webcontent = Nokogiri::HTML(open("https://yellow.co.nz/auckland-region/#{lookfor}?refinements_location=#{area}", 'User-Agent' => 'firefox'))
  end
  searchResults = webcontent.css('h5#searchResultsNumber').text
  puts "=============================================== #{searchResults}"
   resultsCount = searchResults.gsub(' results','')
   if resultsCount.to_i >= 20
     $pages = resultsCount.to_i/20
     unless $pages == 0
       $pages = $pages + 1
     end
   else
     $pages = 1
   end

  $i = 1
  while $i <= $pages  do
    url = "https://yellow.co.nz/auckland-region/#{lookfor}/page/#{$i}?refinements_location=#{area}"
    webcontent = Nokogiri::HTML(open(url, 'User-Agent' => 'firefox'))
    summary = webcontent.css('div.summary')
    summary.each do |name|
      name.css('h2 a').each do |link|
        webpage = "https://yellow.co.nz#{link['href']}"
        companyname = link.text.strip
        puts companyname
        weblist(companyname,webpage,lookfor)
      end
    end
    $i += 1
  end
end

begin
  puts "I'm looking for: "
  lookfor = gets.chomp
  checkFileIfExist(lookfor)
  puts "Now searching for \"#{lookfor}\" in \"Auckland Region\""
  webcontent = Nokogiri::HTML(open("https://yellow.co.nz/auckland-region/#{lookfor}", 'User-Agent' => 'firefox'))

  filterContent = webcontent.css('div.filter-block')
  if filterContent.empty?
    searchByArea("",lookfor)
  else
    filterAreas = filterContent[0].css('div.filter-content label span')
    filterAreas.each do |filterArea|
      area = filterArea.text.strip
      searchByArea(area,lookfor)
    end
  end
rescue => error
  puts "<< Unable to search! >> #{error}"
end
