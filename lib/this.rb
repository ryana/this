module This
  def self.everywhere!
    Object.send :include, self
  end

  class NSThisProxy
    def initialize(obj)
      @obj = obj
    end

    def method_missing(name, *args, &block)
      @obj.send(name, *args, &block)
    end
  end

  private
  def this
    @__this_proxy ||= NSThisProxy.new(self)
  end
end
