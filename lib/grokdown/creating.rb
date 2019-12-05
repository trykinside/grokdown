require 'grokdown'

module Grokdown
  module Creating

    def self.extended(base)
      base.send(:include,InstanceMethods)
    end

    mod = self
    define_method(:recurse) { mod }

    def create(&block)
      @create = block
    end

    def from_node(node)
      if @create
        args = begin
          @create.call(node)
        rescue NoMethodError => e
          raise Error, "cannot find #{e.name} from #{node.to_commonmark.inspect} at #{node.sourcepos[:start_line]}"
        end

        case args
        when Hash
          if self < Hash
            new.merge!(args)
          else
            new(**args)
          end
        else
          new(*args)
        end
      else
        new
      end.tap do |i| i.node=node end
    end

    module InstanceMethods
      def sourcepos
        @node&.sourcepos || {}
      end

      def node=(node)
        @node = node
      end

      def node
        @node
      end
    end
  end
end
