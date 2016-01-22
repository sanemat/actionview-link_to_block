#coding: utf-8
require 'coveralls'
Coveralls.wear!

require 'active_support/version'
autorun_path = Gem::Version.new(ActiveSupport::VERSION::STRING) < Gem::Version.new("4.0")\
  ? 'minitest/autorun'
  : 'active_support/testing/autorun'
require autorun_path
require 'action_controller'
require 'action_view'
require 'action_view/link_to_block/link_to_block'
require 'action_dispatch'
require 'rails-dom-testing' if Gem::Version.new(ActionPack::VERSION::STRING) >= Gem::Version.new("4.2")

# copy from action_view/test/abstract_unit.rb
module RenderERBUtils
  def view
    @view ||= begin
      path = ActionView::FileSystemResolver.new(FIXTURE_LOAD_PATH)
      view_paths = ActionView::PathSet.new([path])
      ActionView::Base.new(view_paths)
    end
  end

  def render_erb(string)
    @virtual_path = nil

    template = ActionView::Template.new(
      string.strip,
      "test template",
      ActionView::Template::Handlers::ERB,
      {})

    template.render(self, {}).strip
  end
end

class LinkToBlockTest < ActiveSupport::TestCase
  attr_accessor :controller, :request

  routes = ActionDispatch::Routing::RouteSet.new
  routes.draw do
    get "/" => "foo#bar"
    get "/other" => "foo#other"
    get "/article/:id" => "foo#article", :as => :article
  end

  include ActionView::Helpers::UrlHelper
  include routes.url_helpers

  dom_assertion = Gem::Version.new(ActionPack::VERSION::STRING) < Gem::Version.new("4.2")\
  ? ActionDispatch::Assertions::DomAssertions
  : Rails::Dom::Testing::Assertions::DomAssertions

  include dom_assertion
  include ActionView::Context
  include RenderERBUtils

  def hash_for(options = {})
    { controller: "foo", action: "bar" }.merge!(options)
  end
  alias url_hash hash_for

  def test_initialization
    [:link_to_block].each do |method|
      assert_includes ActionView::Helpers::UrlHelper.instance_methods, method
    end
  end

  def test_link_tag_with_straight_url
    assert_dom_equal %{<a href="http://www.example.com">Hello</a>}, link_to_block("Hello", "http://www.example.com")
  end

  def test_link_tag_without_host_option
    assert_dom_equal(%{<a href="/">Test Link</a>}, link_to_block('Test Link', url_hash))
  end

  def test_link_tag_with_host_option
    hash = hash_for(host: "www.example.com")
    expected = %{<a href="http://www.example.com/">Test Link</a>}
    assert_dom_equal(expected, link_to_block('Test Link', hash))
  end

  def test_link_tag_with_query
    expected = %{<a href="http://www.example.com?q1=v1&amp;q2=v2">Hello</a>}
    assert_dom_equal expected, link_to_block("Hello", "http://www.example.com?q1=v1&q2=v2")
  end

  def test_link_tag_with_query_and_no_name
    expected = %{<a href="http://www.example.com?q1=v1&amp;q2=v2">http://www.example.com?q1=v1&amp;q2=v2</a>}
    assert_dom_equal expected, link_to_block(nil, "http://www.example.com?q1=v1&q2=v2")
  end

  def test_link_tag_with_block
    assert_dom_equal %{<a href="/"><span>Example site</span></a>},
      link_to_block('/') { content_tag(:span, 'Example site') }
  end

  def test_link_tag_with_block_and_html_options
    assert_dom_equal %{<a class="special" href="/"><span>Example site</span></a>},
      link_to_block('/', class: "special") { content_tag(:span, 'Example site') }
  end

  def test_link_tag_using_block_in_erb
    out = render_erb %{<%= link_to_block('/') do %>Example site<% end %>}
    assert_equal '<a href="/">Example site</a>', out
  end

  def test_link_tag_with_html_safe_string
    assert_dom_equal(
      %{<a href="/article/Gerd_M%C3%BCller">Gerd Müller</a>},
      link_to_block("Gerd Müller", article_path("Gerd_Müller".html_safe))
    )
  end

  def test_link_tag_escapes_content
    assert_dom_equal %{<a href="/">Malicious &lt;script&gt;content&lt;/script&gt;</a>},
      link_to_block("Malicious <script>content</script>", "/")
  end

  def test_link_tag_does_not_escape_html_safe_content
    assert_dom_equal %{<a href="/">Malicious <script>content</script></a>},
      link_to_block("Malicious <script>content</script>".html_safe, "/")
  end

  def test_link_to_unless
    assert_equal "Showing", link_to_block_unless(true, "Showing", url_hash)

    assert_dom_equal %{<a href="/">Listing</a>},
      link_to_block_unless(false, "Listing", url_hash)
  end

  def test_link_tag_unless_with_block
    assert_dom_equal %{<a href="/"><span>Example site</span></a>},
      link_to_block_unless(false, '/') { content_tag(:span, 'Example site') }
  end

  def test_link_tag_unless_with_block_and_html_options
    assert_dom_equal %{<a class="special" href="/"><span>Example site</span></a>},
      link_to_block_unless(false, '/', class: "special") { content_tag(:span, 'Example site') }
  end

  def test_link_tag_unless_using_block_in_erb
    out = render_erb %{<%= link_to_block_unless(false, '/') do %>Example site<% end %>}
    assert_equal '<a href="/">Example site</a>', out
  end

  def test_link_to_block_if
    assert_equal "Showing", link_to_block_if(false, "Showing", url_hash)
    assert_dom_equal %{<a href="/">Listing</a>}, link_to_block_if(true, "Listing", url_hash)
  end

  def request_for_url(url, opts = {})
    env = Rack::MockRequest.env_for("http://www.example.com#{url}", opts)
    ActionDispatch::Request.new(env)
  end

  def test_link_unless_current
    @request = request_for_url("/")

    assert_equal "Showing",
      link_to_block_unless_current("Showing", url_hash)
    assert_equal "Showing",
      link_to_block_unless_current("Showing", "http://www.example.com/")
    assert_equal %{<span>Example site</span>},
      link_to_block_unless_current(url_hash) { content_tag(:span, 'Example site') }

    @request = request_for_url("/?order=desc")

    assert_equal "Showing",
      link_to_block_unless_current("Showing", url_hash)
    assert_equal "Showing",
      link_to_block_unless_current("Showing", "http://www.example.com/")

    @request = request_for_url("/?order=desc&page=1")

    assert_equal "Showing",
      link_to_block_unless_current("Showing", hash_for(order: 'desc', page: '1'))
    assert_equal "Showing",
      link_to_block_unless_current("Showing", "http://www.example.com/?order=desc&page=1")

    @request = request_for_url("/?order=desc")

    assert_equal %{<a href="/?order=asc">Showing</a>},
      link_to_block_unless_current("Showing", hash_for(order: :asc))
    assert_equal %{<a href="http://www.example.com/?order=asc">Showing</a>},
      link_to_block_unless_current("Showing", "http://www.example.com/?order=asc")

    @request = request_for_url("/?order=desc")
    assert_equal %{<a href="/?order=desc&amp;page=2\">Showing</a>},
      link_to_block_unless_current("Showing", hash_for(order: "desc", page: 2))
    assert_equal %{<a href="http://www.example.com/?order=desc&amp;page=2">Showing</a>},
      link_to_block_unless_current("Showing", "http://www.example.com/?order=desc&page=2")

    @request = request_for_url("/show")

    assert_equal %{<a href="/">Listing</a>},
      link_to_block_unless_current("Listing", url_hash)
    assert_equal %{<a href="http://www.example.com/">Listing</a>},
      link_to_block_unless_current("Listing", "http://www.example.com/")
    assert_equal %{<a href="/"><span>Example site</span></a>},
      link_to_block_unless_current(url_hash) { content_tag(:span, 'Example site') }
  end

end
