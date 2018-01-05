class ScrapeController < ApplicationController
  require 'open-uri'
  require 'httparty'

  class Entry
    def initialize(title, price)
      @title = title
      @price = price
    end
    attr_reader :title
    attr_reader :price
  end

  class Post
    def initialize(paragraph)
      @paragraph = paragraph
    end
    attr_reader :paragraph
  end


  def scrape_nike
    doc = Nokogiri::HTML(open("https://store.nike.com/us/en_us/pw/mens-nikeid-lifestyle-shoes/1k9Z7puZoneZoi3?ipp=99"))
    
    item_container = doc.css(".grid-item-info")
    titles = item_container.css(".product-name").css("p").children.map { |name| name.text }.compact
    prices = item_container.css(".product-price").css("span.local").children.map { |price| price.text }.compact
    @entriesArray = []
    (0..prices.size).first(10).each do |index|
      @entriesArray << Entry.new(titles[index], prices[index])
    end
    render template: 'scrape/scrape_nike'
  end

  def scrape_wiki
    doc = HTTParty.get("https://en.wikipedia.org/wiki/Hermione_Granger")
    @parse_page ||= Nokogiri::HTML(doc)
    item_container = @parse_page.css(".mw-parser-output")

    @item_header = @parse_page.css(".firstHeading").text
    @first_para = item_container.css("p")[0].text

    @wiki_paragraph = item_container.map { |name| name.text }.compact

    @wiki_headline = item_container.css(".mw-headline").text
    # @wiki_paragraph = item_container.css("p")[0].text
    @wiki_image = item_container.css(".image").at("img")['src']   
    render template: 'scrape/scrape_wiki'
  end

end
