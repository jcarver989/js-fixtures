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

      self.class.local_fixture_path ||= Dir.mktmpdir
      @location = "#{self.class.local_fixture_path}/#{@name}.html"
      @local_file = File.expand_path(@location)
    end

    def generate
      file = File.open(@local_file, 'w')
      file.syswrite(render_template())
      file.close
    end


    def clone(new_name)
      self.class.new(new_name, 
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
