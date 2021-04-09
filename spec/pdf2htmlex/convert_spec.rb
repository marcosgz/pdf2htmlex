require 'spec_helper'

RSpec.describe Pdf2htmlex do
  class MockProcessStatus
    attr_accessor :exitstatus

    def initialize(exitstatus)
      @exitstatus = exitstatus
    end
  end

  def expect_command_to_match(*parts_of_command)
    Open3.expects(:capture3).with do |*command, _opts|
      command_str = command.join(' ')
      parts_of_command.each do |part_of_command|
        case part_of_command
        when Regexp
          expect(command_str).to match part_of_command
        when String
          expect(command_str).to include part_of_command
        else
          raise "Can't match that"
        end
      end
    end.returns(@result)
  end

  def stub_output(output)
    @result[0] = output
  end

  def stub_error(error)
    @result[1] = error
  end

  def stub_exitstatus(exitstatus)
    @result[2] = MockProcessStatus.new(exitstatus)
  end

  before do
    @result = ['', '', MockProcessStatus.new(0)]
    Open3.stubs(:capture3).returns(@result)
  end

  it 'allows the use of a custom path to the executable' do
    Pdf2htmlex.config.executable = '/custom/path/to/pdf2htmlex'

    expect(Pdf2htmlex.config.executable).to match /^\/custom\/path\/to\/pdf2htmlex/

    Pdf2htmlex.config.executable = 'pdf2htmlex'
  end

  describe '.convert' do
    it 'generates a destination directory' do
      Pdf2htmlex.stubs('make_tempdir').returns('/var/rn/1x')
      expect_command_to_match('--dest-dir /var/rn/1x')

      described_class.convert('file.pdf')
    end

    it 'uses the output filename' do
      expect_command_to_match('./file.pdf output.html')

      described_class.convert('./file.pdf', 'output.html')
    end

    it 'overwrites the destination directory' do
      expect_command_to_match('--dest-dir /tmp/target')

      described_class.convert('file.pdf', dest_dir: '/tmp/target')
    end

    it 'converts true boolean values to 1' do
      expect_command_to_match('--embed-javascript 1')

      described_class.convert('file.pdf', embed_javascript: true)
    end

    it 'converts false boolean values to 0' do
      expect_command_to_match('--embed-javascript 0')

      described_class.convert('file.pdf', embed_javascript: false)
    end

    it 'resolves Proc before convert' do
      expect_command_to_match('--embed-javascript 0')

      described_class.convert('file.pdf', embed_javascript: -> { 1 == 0 })
    end

    it 'converts multiple options and remove those without values' do
      expect_command_to_match(
        '--embed-javascript 0',
        '--dest-dir /tmp/target',
        '--font-format wtf',
        '--clean-tmp 1',
        './file.pdf out.html',
      )

      described_class.convert('./file.pdf', 'out.html',
        embed_javascript: -> { 1 == 0 },
        dest_dir: '/tmp/target',
        font_format: 'wtf',
        tounicode: -1,
        clean_tmp: true,
      )
    end

    it 'raises any errors from pdf2htmlex' do
      stub_error('error message')
      stub_exitstatus(1)
      expect { described_class.convert('filename') }.to raise_error(/pdf2htmlEX failed with: error message/)
    end

    it 'does not raise if pdf2htmlex exit status is 0' do
      stub_error('error message')
      expect { described_class.convert('filename') }.not_to raise_error
    end
  end
end
