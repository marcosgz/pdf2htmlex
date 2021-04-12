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

  [
    [{ last_page: 10 }, ['--last-page 10']],
    [{ zoom: 1.5 }, ['--zoom 1.5']],
    [{ fit_width: 800.0 }, ['--fit-width 800.0']],
    [{ fit_height: 600.0 }, ['--fit-height 600.0']],
    [{ use_cropbox: false }, ['--use-cropbox 0']],
    [{ hdpi: 144 }, ['--hdpi 144']],
    [{ vdpi: 144 }, ['--vdpi 144']],
    [{ embed: true }, ['--embed 1']],
    [{ embed_css: true }, ['--embed-css 1']],
    [{ embed_font: true }, ['--embed-font 1']],
    [{ embed_image: true }, ['--embed-image 1']],
    [{ embed_javascript: true }, ['--embed-javascript 1']],
    [{ embed_outline: true }, ['--embed-outline 1']],
    [{ split_pages: true }, ['--split-pages 1']],
    [{ dest_dir: './' }, ['--dest-dir ./']],
    [{ css_filename: 'style.css' }, ['--css-filename style.css']],
    [{ page_filename: 'p.html' }, ['--page-filename p.html']],
    [{ outline_filename: 'test' }, ['--outline-filename test']],
    [{ process_nontext: true }, ['--process-nontext 1']],
    [{ process_outline: true }, ['--process-outline 1']],
    [{ process_annotation: false }, ['--process-annotation 0']],
    [{ process_form: false }, ['--process-form 0']],
    [{ printing: true }, ['--printing 1']],
    [{ fallback: false }, ['--fallback 0']],
    [{ tmp_file_size_limit: -1 }, ['--tmp-file-size-limit -1']],
    [{ embed_external_font: false }, ['--embed-external-font 0']],
    [{ font_format: 'woff' }, ['--font-format woff']],
    [{ decompose_ligature: true }, ['--decompose-ligature 1']],
    [{ auto_hint: true }, ['--auto-hint 1']],
    [{ external_hint_tool: 'test' }, ['--external-hint-tool test']],
    [{ stretch_narrow_glyph: true }, ['--stretch-narrow-glyph 1']],
    [{ squeeze_wide_glyph: true }, ['--squeeze-wide-glyph 1']],
    [{ override_fstype: true }, ['--override-fstype 1']],
    [{ process_type3: true }, ['--process-type3 1']],
    [{ heps: true }, ['--heps 1']],
    [{ veps: true }, ['--veps 1']],
    [{ space_threshold: 0.125 }, ['--space-threshold 0.125']],
    [{ font_size_multiplier: 4 }, ['--font-size-multiplier 4']],
    [{ space_as_offset: true }, ['--space-as-offset 1']],
    [{ tounicode: -1 }, ['--tounicode -1']],
    [{ optimize_text: true }, ['--optimize-text 1']],
    [{ correct_text_visibility: true }, ['--correct-text-visibility 1']],
    [{ bg_format: 'png' }, ['--bg-format png']],
    [{ svg_node_count_limit: -1 }, ['--svg-node-count-limit -1']],
    [{ svg_embed_bitmap: true }, ['--svg-embed-bitmap 1']],
    [{ owner_password: 'user' }, ['--owner-password user']],
    [{ user_password: 'pass' }, ['--user-password pass']],
    [{ no_drm: true }, ['--no-drm 1']],
    [{ clean_tmp: true }, ['--clean-tmp 1']],
    [{ tmp_dir: '/tmp' }, ['--tmp-dir /tmp']],
    [{ data_dir: '/tmp' }, ['--data-dir /tmp']],
    [{ debug: true }, ['--debug 1']],
    [{ proof: true }, ['--proof 1']],
  ].each do |keywords, expected_options|
    specify do
      expect_command_to_match(*expected_options)

      described_class.convert('file.pdf', **keywords)
    end
  end

end
