module JsFixtures
  class Base
    @@fixtures = []
    @@fixture_types = []

    class << self
      def config(type, &block)
        block.call(get_by_type(type))
      end 

      def create(name, config, &block)
        if config[:type]
          @@fixtures << create_p(config[:type], name, config)
        elsif config[:parent]
          fixture = get_by_name(config[:parent]).clone(name)
          @@fixtures << fixture 
        else
          raise "need either :parent or :type to create fixture"
        end

        block.call(@@fixtures.last)
      end

      def generate_all
        workers = []
        @@fixtures.flatten.each do |f|
          workers << Thread.new { f.generate() }
        end

        workers.each { |w| w.join }
      end

      def get(name)
        get_by_name(name).location
      end

      private 
      def inherited(subclass)
        @@fixture_types << subclass
      end

      def create_p(type, *args)
        get_by_type(type).new(*args)
      end

      def get_by_name(name)
        @@fixtures.each do |f|
          return f if f.name == name
        end

        raise "No Fixture with Name: #{name} found"
      end

      def get_by_type(type)
        @@fixture_types.each do |fixture|
          return fixture if fixture.type == type
        end

        raise "No fixture of type: #{type} found"
      end
    end

    attr_reader :location
    attr_accessor :name
  end
end
