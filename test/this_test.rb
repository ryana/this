require File.join(File.dirname(__FILE__), '..', 'lib', 'this')
require 'rubygems'
require 'bundler'
Bundler.require :default, :test

require 'shoulda'
require 'ruby-debug'

class ThisTest < Test::Unit::TestCase

  class Base
    def run
      this.set = 0
      this.set += 1
    end

    def public_set
      set
    end

    def public_set= val
      set = val
    end

    attr_accessor :set
    private :set, :set=
  end

  class WithThis < Base
    include This
  end

  class WithoutThis < Base
  end

  context "with a WithThis" do
    setup do
      @with_this = WithThis.new
    end

    should "have a private method #this" do
      assert_raises NoMethodError do
        @with_this.this
      end

      assert @with_this.respond_to?(:this, true)
    end

    should "run" do
      assert_equal nil, @with_this.public_set
      @with_this.run
      assert_equal 1, @with_this.public_set
    end

    should "do the wrong set" do
      @with_this.run
      assert_equal 1, @with_this.public_set
      @with_this.public_set = 10
      assert_equal 1, @with_this.public_set
    end
  end

  context "with a WithoutThis" do
    setup do
      @without_this = WithoutThis.new
    end

    should "not have a private method this" do
      assert !@without_this.respond_to?(:this, true)
    end

    should "not run" do
      assert_raises NameError do
        @without_this.run
      end
    end

    context "with everywhere!" do
      setup do
        This.everywhere!
      end

      should "run" do
        @without_this.run
      end
    end
  end

end
