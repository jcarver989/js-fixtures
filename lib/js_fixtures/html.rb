require 'erb'
require 'tmpdir'

module JsFixtures
  class HTML < Base
    @type = :html
    @template = File.join File.dirname(__FILE__), "../../template/html_template.html.erb"

    class << self
      attr_accessor :local_fixture_path
      attr_reader  :type, :template

      def type
        @type.to_sym
      end

      def inherited(subclass)
        super
      end

      def template=(template)
        @template = template
      end
    end

    attr_accessor :scripts, :pre_scripts, :post_scripts

    def initialize(name, config)
      @name     =  name
      @scripts  =  config[:scripts]  ||= []
      @pre_scripts =  config[:settings] ||= "" 
      @post_scripts =  config[:post_scripts] ||= "" 
    end

    def generate
      self.class.local_fixture_path ||= Dir.mktmpdir
      @location = "#{self.class.local_fixture_path}/#{@name}.html"
      p @location

      file = File.open(@location, 'w')
      file.syswrite(render_template())
      @path = File.expand_path(file.path)
      file.close
    end


    def clone
      self.class.new(@name, 
                     :scripts => @scripts.dup, 
                     :settings => @pre_scripts.dup,
                     :post_scripts => @post_scripts.dup)
    end

    private 

    def render_template
      # setup binding 
      name = @name
      pre_scripts = @pre_scripts
      scripts = @scripts
      post_scripts = @post_scripts
      ERB.new(File.read(self.class.template)).result(binding)
    end

  end
end
