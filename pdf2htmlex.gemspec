# frozen_string_literal: true

require_relative 'lib/pdf2htmlex/version'

Gem::Specification.new do |spec|
  spec.name          = 'pdf2htmlex'
  spec.version       = Pdf2htmlex::VERSION
  spec.authors       = ['Marcos G. Zimmermann']
  spec.email         = ['mgzmaster@gmail.com']

  spec.summary       = 'Ruby wrapper for the pdf2htmlEX that convert PDF files to HTML'
  spec.description   = 'pdf2htmlEX helps to convert PDF files into HTML. This simple library uses the pdf2htmlEX tool under the hood.'
  spec.homepage      = 'https://github.com/marcosgz/pdf2htmlex'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/marcosgz/pdf2htmlex'
  spec.metadata['changelog_uri'] = 'https://github.com/marcosgz/blob/main/pdf2htmlex'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.requirements << 'pdf2htmlEX'

  spec.add_development_dependency 'rspec', '~> 3.2'
end
