require 'ferrum'
require 'uri'

module OmniScrapper
  module Crawlers
    module Drivers
      module Ferrum
        attr_accessor :agent

        def prepare_driver
          # TODO: probably we need additional class Driver,
          # which encapsulates all agent specific calls
          self.agent = ::Ferrum::Browser.new(
            timeout: 10,
            browser_options: {
              'headless' => true,
              'disable-gpu' => true,
              'no-sandbox' => true
            }
          )
        end

        # TODO: delegate those methods from crawler to agent
        def set_proxy(host, port)
          #self.agent.set_proxy(host, port)
        end

        def set_user_agent(user_agent)
          #self.agent.user_agent_alias = 'Mac Safari'
        end

        def visit(url)
          agent.goto(url)
        end

        def urls_with_pattern(pattern)
          agent.xpath(pattern)
            .map { |n| url_to(n.attribute('href')) }
        end

        def link_url(pattern)
          path = agent
            .at_xpath(pattern)
            &.attribute('href')
            .to_s
          url_to path
        end

        def current_page_body
          agent.body
        end

        def current_uri
          URI(agent.current_url)
        end
      end
    end
  end
end
