#          Copyright (c) 2009 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require 'redcloth'

module Ramaze
  module View
    module RedCloth
      def self.call(*args)
        ['text/html', render(*args)]
      end

      def self.render(action, string)
        restrictions = action.variables[:redcloth_options] || []
        rules        = action.variables[:redcloth_options] || []

        erubis = Ramaze::View::Erubis.render(action, string)
        redcloth = ::RedCloth.new(erubis, restrictions)
        redcloth.to_html(*rules)
      end
    end
  end
end
