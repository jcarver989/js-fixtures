JsFixtures
===================
A small gem for generating static fixtures from a template for use when testing 3rd party Javascript libraries. 
It can generating fixtures locally or upload them to Amazon's s3 for when you want to run tests remotely (e.x. off of a selenium grid)


Installation
------------------

    gem install js-fixtures

    # in your app
    require 'js_fixtures'

Usage
-----------------


### Setup LocalTests

    require 'js_fixtures'
    
    JsFixtures.config :html do |config|
      # override the default html template (optional)
      config.template = "/templates/html_template.html.erb" 

      # path where fixtures get generated
      config.local_fixture_path = "test/functional/fixtures/"
    end

### Setup Tests uploaded to S3

    require 'js_fixtures'
    
    JsFixtures.config :html_s3 do |config|
      # path where fixtures get generated
      config.local_fixture_path = "test/functional/fixtures/"

      # path to save fixtures in s3
      config.s3_path = "mys3bucket:cool-js-project/fixtures"
    end


### Creating Fixtures
By default html fixtures and html_s3 fixtures use an html template that accepts an array of scripts to load in addition to optional Javascript code to execute before/after loading these scripts

    JsFixtures.create :base_fixture, :type => :html_s3 do |f|
      f.pre_scripts <<-PRE
        // javascript code to load before your main scripts
      PRE

      f.scripts = ["http://my-site.com/my_script.js"] 

      f.post_scripts <<-POST
        MyScript.init()
      POST
    end


    JsFixtures.create :with_some_settings, :type => :html_s3 do |f|
      f.pre_scripts += <<-PRE
        window._some_setting = true
      PRE

      f.post_scripts += <<-POST
        MyScript.printResults()
      POST
    end


### Generating Fixtures 
After you've defined all your fixtures and are ready to generate them. This will call generate() on every fixture that has been created so far.

    JsFixtures.generate_all


An example test using rspec + capybara :

    it "should do something" do 
      fixture_location = JsFixtures.get :with_some_settings
      page.visit(fixture_location)
      page.should have_xpath('//table/tr')
    end

### Custom Fixture Types
    
You can create custom fixture types by extending the Base class like so:

    class MyFixture < JsFixtures::Base
      @type = :my_fixture

      class << self
       attr_accessor :use_debugger
       # other config methods here
      end

      def initialize(name)
        super
        @name = name
      end

      def generate
        puts "do something here"
        @location = "path/to/generated/fixture"
      end
    end


Then create your fixture

    JsFixtures.create :a_fixture, :type => :my_fixture do |f|
      f.use_debugger = true
    end
