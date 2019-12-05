require 'commonmarker/node'
require 'grokdown'

module Grokdown
  module Matching
    class << self
      @@knowns = []

      def extended(base)
        base.send(:include,InstanceMethods)
        @@knowns.push(base)
      end

      def matches?(node)
        @@knowns.any? {|i| i.matches?(node)}
      end

      def matching(node)
        @@knowns.find {|i| i.matches?(node)}
      end

      alias_method :===, :matches?
    end

    def match(&block)
      @matcher = block
    end

    def matches?(node)
      node.is_a?(self) || (node.is_a?(CommonMarker::Node) && @matcher.call(node))
    end

    module InstanceMethods
      alias_method :===, :matches?
    end
  end
end
