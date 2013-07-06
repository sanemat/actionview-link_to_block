module LinkToBlock
  module ::ActionView
    module Helpers
      module UrlHelper
        alias_method :link_to_block, :link_to
      end
    end
  end
end
