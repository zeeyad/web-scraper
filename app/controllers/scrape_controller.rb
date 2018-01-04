class ScrapeController < ApplicationController

  class Entry
    def initialize(title, price)
      @title = title
      @price = price
    end
    attr_reader :title
    attr_reader :price
  end

  def scrape_reddit
    require 'open-uri'
    doc = Nokogiri::HTML(open("https://store.nike.com/us/en_us/pw/mens-nikeid-lifestyle-shoes/1k9Z7puZoneZoi3?ipp=99"))
    
    item_container = doc.css(".grid-item-info")
    titles = item_container.css(".product-name").css("p").children.map { |name| name.text }.compact
    prices = item_container.css(".product-price").css("span.local").children.map { |price| price.text }.compact

    @entriesArray = []
    (0..prices.size).first(10).each do |index|
      @entriesArray << Entry.new(titles[index], prices[index])
    end
   
    render template: 'scrape/scrape_reddit'
  end

end
