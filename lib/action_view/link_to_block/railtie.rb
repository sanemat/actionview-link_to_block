module ActionView
  module LinkToBlock
    class Railtie < ::Rails::Railtie
      initializer 'actionview-link_to_block' do |app|
        ActiveSupport.on_load(:action_view) do
          require 'action_view/link_to_block/actionview-link_to_block'
        end
      end
    end
  end
end
