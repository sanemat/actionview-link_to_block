module LinkToBlock
  module ::ActionView
    module Helpers
      module UrlHelper
        alias_method :link_to_block, :link_to

        def link_to_block_unless(condition, name = nil, options = {}, html_options = {}, &block)
          if condition
            if block_given?
              capture(&block)
            else
              ERB::Util.html_escape(name)
            end
          else
            if block_given?
              html_options, options = options, name
              link_to capture(&block), options, html_options
            else
              link_to name, options, html_options
            end
          end
        end

        def link_to_block_if(condition, name = nil, options = {}, html_options = {}, &block)
          link_to_block_unless !condition, name, options, html_options, &block
        end

        def link_to_block_unless_current(name = nil, options = {}, html_options = {}, &block)
          if block_given?
            html_options, options = options, name
            link_to_block_unless current_page?(options), options, html_options, &block
          else
            link_to_block_unless current_page?(options), name, options, html_options
          end
        end
      end
    end
  end
end
