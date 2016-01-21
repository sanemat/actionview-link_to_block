# Actionview::LinkToBlock

[![Gem Version](https://badge.fury.io/rb/actionview-link_to_block.png)](http://badge.fury.io/rb/actionview-link_to_block)
[![Build Status](https://api.travis-ci.org/sanemat/actionview-link_to_block.png?branch=master)](https://travis-ci.org/sanemat/actionview-link_to_block)
[![Code Climate](https://codeclimate.com/github/sanemat/actionview-link_to_block.png)](https://codeclimate.com/github/sanemat/actionview-link_to_block)
[![Coverage Status](https://coveralls.io/repos/sanemat/actionview-link_to_block/badge.png?branch=master)](https://coveralls.io/r/sanemat/actionview-link_to_block)

Add helper method, `link_to_block`, `link_to_block_if`, `link_to_block_unless`, `link_to_block_unless_current`.
This is symmetrical to `link_to`, `link_to_if`, `link_to_unless`, `link_to_unless_current`.

`link_to_block*` always accepts block.

## Usage

`link_to` accepts complex html as block, like below:

    <%= link_to user_path(@user) do %>
      <i class="icon-ok icon-white"></i> Do it@
    <% end %>
    # http://stackoverflow.com/questions/9401942/using-link-to-with-embedded-html

But `link_to_if` with block behavior is below:

    <%= link_to_if condition, user_path(@user) do %>
      Appear if condition falsy
    <% end %>

Then use `link_to_block_if` below:

    <%= link_to_block_if condition, user_path(@user) do %>
      <i class="icon-ok icon-white"></i> Do it@
    <% end %>

    #=> if condition truthy, then shows html and link, else if condition falsy, then show only html.

## Installation

Add this line to your application's Gemfile:

    gem 'actionview-link_to_block'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install actionview-link_to_block

## Requirement

`actionview-link_to_block` has no gem dependency in gemspec, but this is not correctly.
`actionview` extracts from `actionpack` on rails4.1.
You can see `Appraisals` file and `/gemfiles` directory.

actionview master(rails master)

    gem 'actionview', github: 'rails', branch: 'master'
    gem 'actionpack', github: 'rails', branch: 'master'

actionview v5.0(rails v5.0)

    gem 'actionview', '~> 5.0.0.beta'
    gem 'actionpack', '~> 5.0.0.beta'

actionview v4.2(rails v4.2)

    gem 'actionview', '~> 4.2.0'
    gem 'actionpack', '~> 4.2.0'

actionview v4.1(rails v4.1)

    gem 'actionpack', '~> 4.1.0'

actionpack v4.0(rails v4.0)

    gem 'actionpack', '~> 4.0.0'

actionpack v3.2(rails v3.2)

    gem 'actionpack', '~> 3.2.0'

## Testing

Test against actionpack v3.2, v4.0, v4.1, v4.2, v5.0, master run below:

    $ bundle
    $ bundle exec appraisal install
    $ bundle exec appraisal rake

Test for specific version:

    $ bundle exec appraisal install
    $ bundle exec appraisal actionpack_4_0 rake

Prepare actionpack_3_2(gem), actionpack_4_0(gem), actionview_4_1(gem), actionview_4_2(gem), actionview_5_0(gem), actionview_master(github)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
