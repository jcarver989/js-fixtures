Gem::Specification.new do |spec|
  spec.name ="js-fixtures"
  spec.version = "0.0.1"
  spec.summary = "An easy way to handle your javascript/html fixtures"
  spec.authors = ["Joshua Carver"]
  spec.email = "jcarver989@gmail.com"
  spec.executables = []
  spec.has_rdoc = false
  spec.require_paths = ["lib"]
  spec.files = []
  spec.files += Dir.glob("lib/**/*")
  spec.add_dependency("sinatra")
  spec.add_dependency("right_aws")

  spec.add_development_dependency("rspec")
end
