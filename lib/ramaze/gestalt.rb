#          Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

=begin rdoc
Example:

  require 'ramaze'
  require 'ramaze/gestalt'

  def random_color
    r = lambda{|n| rand(n).to_s(16) }
    '#' + [255, 255, 255].map{r[255] + r[255] + r[255]
  end

  puts Ramaze::Gestalt.build{
    html do
      head do
        title{"Hello World"}
      end
      body do
        h1{"Hello, World!"}
        div(:style => 'width:100%') do
          10.times do
            div(:style => "width:#{rand(100)}%;height:#{rand(100)}%;background:#{random_color}"){ '&nbsp;' }
          end
        end
      end
    end
  }
=end

module Ramaze

  # Gestalt is the custom HTML/XML builder for Ramaze, based on a very simple
  # DSL it will build your markup.

  class Gestalt
    attr_accessor :out

    # The default way to start building your markup.
    # Takes a block and returns the markup.
    #
    # Example:
    #   html =
    #     Gestalt.build do
    #       html do
    #         head do
    #           title "Hello, World!"
    #         end
    #         body do
    #           h1 "Hello, World!"
    #         end
    #       end
    #     end
    #

    def self.build &block
      self.new(&block).to_s
    end

    # Gestalt.new is like ::build but will return itself.
    # you can either access #out or .to_s it, which will
    # return the actual markup.
    #
    # Useful for distributed building of one page.

    def initialize &block
      @out = ''
      instance_eval(&block) if block_given?
    end

    # catching all the tags. passing it to _gestalt_build_tag

    def method_missing meth, *args, &block
      _gestalt_build_tag meth, *args, &block
    end

    # workaround for Kernel#p to make <p /> tags possible.

    def p *args, &block
      _gestalt_build_tag :p, *args, &block
    end

    # build a tag for `name`, using `args` and an optional block that
    # will be yielded

    def _gestalt_build_tag name, args = []
      @out << "<#{name}"
      if block_given?
        @out << args.inject(''){ |s,v| s << %{ #{v[0]}="#{v[1]}"} }
        @out << ">"
        text = yield
        @out << text if text != @out and text.respond_to?(:to_str)
        @out << "</#{name}>"
      else
        @out << args.inject(''){ |s,v| s << %{ #{v[0]}="#{v[1]}"} }
        @out << ' />'
      end
    end

    # @out.to_s

    def to_s
      @out.to_s
    end
    alias to_str to_s
  end
end
