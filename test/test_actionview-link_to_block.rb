require 'active_support/version'
autorun_path = ActiveSupport::VERSION::STRING.start_with?('3')\
  ? 'minitest/autorun'
  : 'active_support/testing/autorun'
require autorun_path
require 'action_view'
require 'action_view/link_to_block/link_to_block'

class LinkToBlockTest < ActiveSupport::TestCase
  def test_initialization
    [:link_to_block].each do |method|
      assert_includes ActionView::Helpers::UrlHelper.instance_methods, method
    end
  end
end
