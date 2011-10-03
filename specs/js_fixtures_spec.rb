require File.join File.dirname(__FILE__), "../lib/js_fixtures"
require 'fileutils'
require 'tmpdir'
require 'rspec'


describe "Html fixtures" do 
  before(:all) do 
    @dir = Dir.mktmpdir

    JsFixtures.config :html do |config|
      # path where fixtures get generated
      config.local_fixture_path = @dir 
    end
  end

  after(:all) do
    FileUtils.remove_entry_secure @dir
  end

  it "should create a fixture" do 
    JsFixtures.create :test, :type => :html do |f|
    end

    JsFixtures.get_location(:test).should == "#{@dir}/test.html"
  end


  context "basic fixture" do
    before(:all) do 
      JsFixtures.create :test, :type => :html do |f|
        f.pre_scripts   = "foo"
        f.scripts       = ["http://moogle.com/js", "http://boogle.com/js"]
        f.post_scripts  = "boo"
      end

      JsFixtures.generate_all
      @fixture = File.read JsFixtures.get_location(:test)
    end

    it "should have moogle script" do 
      @fixture.should include('<script type="text/javascript" src="http://moogle.com/js"></script>')
    end

    it "should have boogle script" do
      @fixture.should include('<script type="text/javascript" src="http://boogle.com/js"></script>')
    end

    it "should have foo as pre script" do 
      @fixture.should match(/<head>\s+<script.*>\s+foo/)
    end

    it "should have boo as post script" do
      @fixture.should match(/<script.*>\s+boo\s+<\/script>\s+<\/head>/)
    end
  end


end 
