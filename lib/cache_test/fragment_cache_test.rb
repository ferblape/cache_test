module CacheTest

  class NoRequestInBlockError < StandardError #:nodoc:
  end

  class NoControllerDefinedError < StandardError #:nodoc:
  end

  module Assertions

    # asserts that the list of given fragment name are being cached
    def assert_cache_fragments(*names)
    
      fragment_cache_store.clear
    
      yield *names
    
      # if there is no variable @controller, then we haven't done any request
      raise NoRequestInBlockError.new("no request was send while executing block.") if @controller.nil?
    
      names.each do |name|
        assert_block("#{name.inspect} is not cached after executing block") do
          fragment_cache_store.written?(@controller.fragment_cache_key(name))
        end
      end
    
      fragment_cache_store.clear

    end

    alias :assert_cache_fragment :assert_cache_fragments

    # asserts that the list of given fragment name are not being cached
    def assert_not_cache_fragments(*names)
    
      fragment_cache_store.clear
    
      yield *names
    
      # if there is no variable @controller, then we haven't done any request
      raise NoRequestInBlockError.new("no request was send while executing block.") if @controller.nil?
    
      names.each do |name|
        assert_block("#{name.inspect} is cached after executing block") do
          !fragment_cache_store.written?(@controller.fragment_cache_key(name))
        end
      end
    
      fragment_cache_store.clear

    end

    alias :assert_not_cache_fragment :assert_not_cache_fragments

    # assert that the list of given fragment are being expired
    def assert_expire_fragments(*names)
      fragment_cache_store.clear
    
      yield *names

      raise NoRequestInBlockError.new("no request was send while executing block.") if @controller.nil?
    
      names.each do |name|
        assert_block("#{name.inspect} is not expired after executing block") do
          fragment_cache_store.deleted?(@controller.fragment_cache_key(name))
        end
      end
    
      fragment_cache_store.clear
    end
    
    alias :assert_expire_fragment :assert_expire_fragments

    # assert that the list of given fragment are not being expired
    def assert_not_expire_fragments(*names)
      fragment_cache_store.clear
    
      yield *names

      raise NoRequestInBlockError.new("no request was send while executing block.") if @controller.nil?
    
      names.each do |name|
        assert_block("#{name.inspect} is expired after executing block") do
          !fragment_cache_store.deleted?(@controller.fragment_cache_key(name))
        end
      end
    
      fragment_cache_store.clear
    end

    # assert that the given action is being cached
    def assert_cache_action
      fragment_cache_store.clear
      
      yield 
           
      assert_block("#{@controller.params.inspect} is not cached after executing block. Expected: #{@controller.fragment_cache_key(@controller.params)}") do
        path = @controller.fragment_cache_key(@controller.params)
        path << 'index' if path.last == '/'
        path << ".#{@controller.params[:format]}" if @controller.params[:format] && @controller.params[:format] != 'html'
        fragment_cache_store.written?(path)
      end
    
      fragment_cache_store.clear
    end

    # assert that the given actions are not being cached
    def assert_not_cache_actions(*actions)
    
      fragment_cache_store.clear
    
      yield *actions
   
      raise NoRequestInBlockError.new("no request was send while executing block.") if @controller.nil?
    
      actions.each do |action|
        action = { :action => action } unless action.is_a?(Hash)
        assert_block("#{action.inspect} is cached after executing block. Cached: #{}") do
          path = @controller.fragment_cache_key(action)
          path << 'index' if path.last == '/'
          path << ".#{@controller.params[:format]}" if @controller.params[:format] && @controller.params[:format] != 'html'
          !fragment_cache_store.written?(path)
        end
      end
    
      fragment_cache_store.clear
    
    end
  
    alias :assert_not_cache_action :assert_not_cache_actions
  
    # assert that the given actions are being expired
    def assert_expire_actions(*actions)
      fragment_cache_store.clear
    
      yield *actions
    
      raise NoRequestInBlockError.new("no request was send while executing block.") if @controller.nil?
    
      actions.each do |action|
        action = { :action => action } unless action.is_a?(Hash)
        assert_block("#{action.inspect} is not expired after executing block. Cached: #{}") do
          path = @controller.fragment_cache_key(action)
          path << 'index' if path.last == '/'
          path << ".#{@controller.params[:format]}" if @controller.params[:format] && @controller.params[:format] != 'html'
          fragment_cache_store.deleted?(path)
        end
      end
    
      fragment_cache_store.clear
    end
  
    alias :assert_expire_action :assert_expire_actions

    # assert that the given actions are not being expired
    def assert_not_expire_actions(*actions)    
      fragment_cache_store.clear
    
      yield *actions
    
      raise NoRequestInBlockError.new("no request was send while executing block.") if @controller.nil?
    
      actions.each do |action|
        action = { :action => action } unless action.is_a?(Hash)
        assert_block("#{action.inspect} is expired after executing block. Cached: #{}") do
          path = @controller.fragment_cache_key(action)
          path << 'index' if path.last == '/'
          path << ".#{@controller.params[:format]}" if @controller.params[:format] && @controller.params[:format] != 'html'
          !fragment_cache_store.deleted?(path)
        end
      end
    
      fragment_cache_store.clear
    end

    alias :assert_not_expire_action :assert_not_expire_actions

    private
  
      def fragment_cache_store
        ActionController::Base.cache_store
      end
  
  end
end