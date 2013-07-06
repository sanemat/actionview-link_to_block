require 'active_support/version'
autorun_path = ActiveSupport::VERSION::STRING.start_with?('3')\
  ? 'minitest/autorun'
  : 'active_support/testing/autorun'
require autorun_path
require 'action_view'
require 'action_view/link_to_block/link_to_block'
require 'action_dispatch'

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

  include ActionDispatch::Assertions::DomAssertions

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
    assert_dom_equal %{<a href="http://www.example.com">Hello</a>}, link_to("Hello", "http://www.example.com")
  end

  def test_link_tag_without_host_option
    assert_dom_equal(%{<a href="/">Test Link</a>}, link_to('Test Link', url_hash))
  end

  def test_link_tag_with_host_option
    hash = hash_for(host: "www.example.com")
    expected = %{<a href="http://www.example.com/">Test Link</a>}
    assert_dom_equal(expected, link_to('Test Link', hash))
  end

  def test_link_tag_with_query
    expected = %{<a href="http://www.example.com?q1=v1&amp;q2=v2">Hello</a>}
    assert_dom_equal expected, link_to("Hello", "http://www.example.com?q1=v1&q2=v2")
  end

  def test_link_tag_with_query_and_no_name
    expected = %{<a href="http://www.example.com?q1=v1&amp;q2=v2">http://www.example.com?q1=v1&amp;q2=v2</a>}
    assert_dom_equal expected, link_to(nil, "http://www.example.com?q1=v1&q2=v2")
  end

  # def test_link_tag_with_back
  #   env = {"HTTP_REFERER" => "http://www.example.com/referer"}
  #   @controller = Struct.new(:request).new(Struct.new(:env).new(env))
  #   expected = %{<a href="#{env["HTTP_REFERER"]}">go back</a>}
  #   assert_dom_equal expected, link_to('go back', :back)
  # end

  # def test_link_tag_with_back_and_no_referer
  #   @controller = Struct.new(:request).new(Struct.new(:env).new({}))
  #   link = link_to('go back', :back)
  #   assert_dom_equal %{<a href="javascript:history.back()">go back</a>}, link
  # end

  # def test_link_tag_with_img
  #   link = link_to("<img src='/favicon.jpg' />".html_safe, "/")
  #   expected = %{<a href="/"><img src='/favicon.jpg' /></a>}
  #   assert_dom_equal expected, link
  # end

  # def test_link_with_nil_html_options
  #   link = link_to("Hello", url_hash, nil)
  #   assert_dom_equal %{<a href="/">Hello</a>}, link
  # end

  # def test_link_tag_with_custom_onclick
  #   link = link_to("Hello", "http://www.example.com", onclick: "alert('yay!')")
  #   expected = %{<a href="http://www.example.com" onclick="alert(&#39;yay!&#39;)">Hello</a>}
  #   assert_dom_equal expected, link
  # end

  # def test_link_tag_with_javascript_confirm
  #   assert_dom_equal(
  #     %{<a href="http://www.example.com" data-confirm="Are you sure?">Hello</a>},
  #     link_to("Hello", "http://www.example.com", data: { confirm: "Are you sure?" })
  #   )
  #   assert_dom_equal(
  #     %{<a href="http://www.example.com" data-confirm="You cant possibly be sure, can you?">Hello</a>},
  #     link_to("Hello", "http://www.example.com", data: { confirm: "You cant possibly be sure, can you?" })
  #   )
  #   assert_dom_equal(
  #     %{<a href="http://www.example.com" data-confirm="You cant possibly be sure,\n can you?">Hello</a>},
  #     link_to("Hello", "http://www.example.com", data: { confirm: "You cant possibly be sure,\n can you?" })
  #   )
  # end

  # def test_link_to_with_remote
  #   assert_dom_equal(
  #     %{<a href="http://www.example.com" data-remote="true">Hello</a>},
  #     link_to("Hello", "http://www.example.com", remote: true)
  #   )
  # end

  # def test_link_to_with_remote_false
  #   assert_dom_equal(
  #     %{<a href="http://www.example.com">Hello</a>},
  #     link_to("Hello", "http://www.example.com", remote: false)
  #   )
  # end

  # def test_link_to_with_symbolic_remote_in_non_html_options
  #   assert_dom_equal(
  #     %{<a href="/" data-remote="true">Hello</a>},
  #     link_to("Hello", hash_for(remote: true), {})
  #   )
  # end

  # def test_link_to_with_string_remote_in_non_html_options
  #   assert_dom_equal(
  #     %{<a href="/" data-remote="true">Hello</a>},
  #     link_to("Hello", hash_for('remote' => true), {})
  #   )
  # end

  # def test_link_tag_using_post_javascript
  #   assert_dom_equal(
  #     %{<a href="http://www.example.com" data-method="post" rel="nofollow">Hello</a>},
  #     link_to("Hello", "http://www.example.com", method: :post)
  #   )
  # end

  # def test_link_tag_using_delete_javascript
  #   assert_dom_equal(
  #     %{<a href="http://www.example.com" rel="nofollow" data-method="delete">Destroy</a>},
  #     link_to("Destroy", "http://www.example.com", method: :delete)
  #   )
  # end

  # def test_link_tag_using_delete_javascript_and_href
  #   assert_dom_equal(
  #     %{<a href="\#" rel="nofollow" data-method="delete">Destroy</a>},
  #     link_to("Destroy", "http://www.example.com", method: :delete, href: '#')
  #   )
  # end

  # def test_link_tag_using_post_javascript_and_rel
  #   assert_dom_equal(
  #     %{<a href="http://www.example.com" data-method="post" rel="example nofollow">Hello</a>},
  #     link_to("Hello", "http://www.example.com", method: :post, rel: 'example')
  #   )
  # end

  # def test_link_tag_using_post_javascript_and_confirm
  #   assert_dom_equal(
  #     %{<a href="http://www.example.com" data-method="post" rel="nofollow" data-confirm="Are you serious?">Hello</a>},
  #     link_to("Hello", "http://www.example.com", method: :post, data: { confirm: "Are you serious?" })
  #   )
  # end

  # def test_link_tag_using_delete_javascript_and_href_and_confirm
  #   assert_dom_equal(
  #     %{<a href="\#" rel="nofollow" data-confirm="Are you serious?" data-method="delete">Destroy</a>},
  #     link_to("Destroy", "http://www.example.com", method: :delete, href: '#', data: { confirm: "Are you serious?" })
  #   )
  # end

  # def test_link_tag_with_block
  #   assert_dom_equal %{<a href="/"><span>Example site</span></a>},
  #     link_to('/') { content_tag(:span, 'Example site') }
  # end

  # def test_link_tag_with_block_and_html_options
  #   assert_dom_equal %{<a class="special" href="/"><span>Example site</span></a>},
  #     link_to('/', class: "special") { content_tag(:span, 'Example site') }
  # end

  # def test_link_tag_using_block_in_erb
  #   out = render_erb %{<%= link_to('/') do %>Example site<% end %>}
  #   assert_equal '<a href="/">Example site</a>', out
  # end

  # def test_link_tag_with_html_safe_string
  #   assert_dom_equal(
  #     %{<a href="/article/Gerd_M%C3%BCller">Gerd Müller</a>},
  #     link_to("Gerd Müller", article_path("Gerd_Müller".html_safe))
  #   )
  # end

  # def test_link_tag_escapes_content
  #   assert_dom_equal %{<a href="/">Malicious &lt;script&gt;content&lt;/script&gt;</a>},
  #     link_to("Malicious <script>content</script>", "/")
  # end

  # def test_link_tag_does_not_escape_html_safe_content
  #   assert_dom_equal %{<a href="/">Malicious <script>content</script></a>},
  #     link_to("Malicious <script>content</script>".html_safe, "/")
  # end

  # def test_link_to_unless
  #   assert_equal "Showing", link_to_unless(true, "Showing", url_hash)

  #   assert_dom_equal %{<a href="/">Listing</a>},
  #     link_to_unless(false, "Listing", url_hash)

  #   assert_equal "Showing", link_to_unless(true, "Showing", url_hash)

  #   assert_equal "<strong>Showing</strong>",
  #     link_to_unless(true, "Showing", url_hash) { |name|
  #       "<strong>#{name}</strong>".html_safe
  #     }

  #   assert_equal "test",
  #     link_to_unless(true, "Showing", url_hash) {
  #       "test"
  #     }

  #   assert_equal %{&lt;b&gt;Showing&lt;/b&gt;}, link_to_unless(true, "<b>Showing</b>", url_hash)
  #   assert_equal %{<a href="/">&lt;b&gt;Showing&lt;/b&gt;</a>}, link_to_unless(false, "<b>Showing</b>", url_hash)
  #   assert_equal %{<b>Showing</b>}, link_to_unless(true, "<b>Showing</b>".html_safe, url_hash)
  #   assert_equal %{<a href="/"><b>Showing</b></a>}, link_to_unless(false, "<b>Showing</b>".html_safe, url_hash)
  # end

  # def test_link_to_if
  #   assert_equal "Showing", link_to_if(false, "Showing", url_hash)
  #   assert_dom_equal %{<a href="/">Listing</a>}, link_to_if(true, "Listing", url_hash)
  #   assert_equal "Showing", link_to_if(false, "Showing", url_hash)
  # end

  # def request_for_url(url, opts = {})
  #   env = Rack::MockRequest.env_for("http://www.example.com#{url}", opts)
  #   ActionDispatch::Request.new(env)
  # end

  # def test_current_page_with_http_head_method
  #   @request = request_for_url("/", :method => :head)
  #   assert current_page?(url_hash)
  #   assert current_page?("http://www.example.com/")
  # end

  # def test_current_page_with_simple_url
  #   @request = request_for_url("/")
  #   assert current_page?(url_hash)
  #   assert current_page?("http://www.example.com/")
  # end

  # def test_current_page_ignoring_params
  #   @request = request_for_url("/?order=desc&page=1")

  #   assert current_page?(url_hash)
  #   assert current_page?("http://www.example.com/")
  # end

  # def test_current_page_with_params_that_match
  #   @request = request_for_url("/?order=desc&page=1")

  #   assert current_page?(hash_for(order: "desc", page: "1"))
  #   assert current_page?("http://www.example.com/?order=desc&page=1")
  # end

  # def test_current_page_with_not_get_verb
  #   @request = request_for_url("/events", method: :post)

  #   assert !current_page?('/events')
  # end

  # def test_link_unless_current
  #   @request = request_for_url("/")

  #   assert_equal "Showing",
  #     link_to_unless_current("Showing", url_hash)
  #   assert_equal "Showing",
  #     link_to_unless_current("Showing", "http://www.example.com/")

  #   @request = request_for_url("/?order=desc")

  #   assert_equal "Showing",
  #     link_to_unless_current("Showing", url_hash)
  #   assert_equal "Showing",
  #     link_to_unless_current("Showing", "http://www.example.com/")

  #   @request = request_for_url("/?order=desc&page=1")

  #   assert_equal "Showing",
  #     link_to_unless_current("Showing", hash_for(order: 'desc', page: '1'))
  #   assert_equal "Showing",
  #     link_to_unless_current("Showing", "http://www.example.com/?order=desc&page=1")

  #   @request = request_for_url("/?order=desc")

  #   assert_equal %{<a href="/?order=asc">Showing</a>},
  #     link_to_unless_current("Showing", hash_for(order: :asc))
  #   assert_equal %{<a href="http://www.example.com/?order=asc">Showing</a>},
  #     link_to_unless_current("Showing", "http://www.example.com/?order=asc")

  #   @request = request_for_url("/?order=desc")
  #   assert_equal %{<a href="/?order=desc&amp;page=2\">Showing</a>},
  #     link_to_unless_current("Showing", hash_for(order: "desc", page: 2))
  #   assert_equal %{<a href="http://www.example.com/?order=desc&amp;page=2">Showing</a>},
  #     link_to_unless_current("Showing", "http://www.example.com/?order=desc&page=2")

  #   @request = request_for_url("/show")

  #   assert_equal %{<a href="/">Listing</a>},
  #     link_to_unless_current("Listing", url_hash)
  #   assert_equal %{<a href="http://www.example.com/">Listing</a>},
  #     link_to_unless_current("Listing", "http://www.example.com/")
  # end

end
