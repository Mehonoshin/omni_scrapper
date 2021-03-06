require 'omni_scrapper/exceptions/crawler_not_defined_exception'

module OmniScrapper
  class Configuration
    attr_reader :fields, :anchors
    attr_accessor :scrapping_error_handler, :scrapping_success_handler, 
      :scrapping_start_handler

    SINGLE_OPTS = %i[ do method ]

    def initialize
      @scrapping_success_handler = Proc.new { |_, _| }
      @scrapping_error_handler = Proc.new { |_, _| }
      @scrapping_start_handler = Proc.new { |_| }

      @fields = {}
      @anchors = {}
    end

    # TODO: make config.crawler.blabla
    # to define crawler-specific fields,
    # in similar to fields definition manner
    def field(name, options = {})
      #validate_crawler_presence!(options)
      validate_field_options!(options)
      # TODO: validate if field method is defined
      @fields[name] = options
    end

    def method_missing(method_name, *args, &block)
      if args.empty?
        get_variable(method_name)
      else
        set_variable(method_name, args)
      end
    end

    private

    def set_variable(name, options)
      @anchors[name] = { pattern: options[0] }
    end

    def get_variable(name)
      # TODO: raise error if unexisting field is requested
      @anchors[name][:pattern]
    end

    def validate_crawler_presence!(options)
      #return if
      fail OmniScrapper::CrawlerNotDefinedException
    end

    # TODO: most probably it should be removed, since we don't support ruby procs anymore
    def validate_field_options!(options)
      incorrect_options = (SINGLE_OPTS & options.keys).first
      return unless incorrect_options && options.keys.size > 1
      incompatible_options = (options.keys - [incorrect_options]).map { |i| ":#{i}" }.join(', ')
      exception_message = ":#{incorrect_options} can not be used with other args(#{incompatible_options})"
      fail OmniScrapper::InvalidFieldArgumentsException, exception_message
    end
  end
end
