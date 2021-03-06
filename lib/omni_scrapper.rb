require 'omni_scrapper/crawlers'
require 'omni_scrapper/normalizers'
require 'omni_scrapper/result'
require 'omni_scrapper/page'
require 'omni_scrapper/schema'
require 'omni_scrapper/configuration'
require 'omni_scrapper/scrapper_builder'

module OmniScrapper
  class << self
    # Builds an omni_scrapper class based on provided configuration
    def setup(scrapper_name)
      config = OmniScrapper::Configuration.new
      yield(config)
      OmniScrapper::ScrapperBuilder.new(scrapper_name, config).build_class
    end
  end
end
