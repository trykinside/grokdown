module Grokdown
  class NeverConsumes < BasicObject
    def initialize(node)
      @node = node
    end

    def consumes?(*)
      false
    end

    def method_missing(name,*args,**kargs,&block)
      if kargs.empty?
        @node.send(name,*args,&block)
      else
        @node.send(name,*args,**kargs,&block)
      end
    end

    def node
      @node
    end
  end
end
