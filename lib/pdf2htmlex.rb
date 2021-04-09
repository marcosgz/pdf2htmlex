# frozen_string_literal: true

# @see https://www.rubydoc.info/stdlib/open3/Open3.popen3
require 'open3'
# @see https://www.rubydoc.info/stdlib/pathname/Pathname
require 'pathname'
# @see https://ruby-doc.com/stdlib/libdoc/tmpdir/rdoc/Dir.html
require 'tmpdir'

require_relative 'pdf2htmlex/version'
require_relative 'pdf2htmlex/config'

# Ruby wrapper for the pdf2htmlEX tool
#
# `pdf2htmlEX` converts PDF to HTML while retaining text, format and style as much as
# possible by making use of HTML5, JavaScript and modern CSS features. Even difficult
# content like PDFs with embedded fonts, multicolumn documents, scientific papers with
# complicated figures and mathematical formulas will mostly be represented correctly.
# Fallback mode generates HTML pages which do not require any JavaScript to view them
# correctly at the expense of a larger file size.
#
# @see https://github.com/coolwanglu/pdf2htmlEX
module Pdf2htmlex
  class Error < StandardError; end

  extend self

  # Convert input PDF file to HTML
  #
  # @param input_pdf [String, Pathname] The path of PDF file
  # @param html_filename [String, Pathname, NilClass] The output HTML filename
  # @param options [Hash] List of pdf2htmlex options
  # @option [Integer] :first_page (default: 1) First page to convert
  # @option [Integer] :last_page (default: 2147483647) Last page to convert
  # @option [Float] :zoom Zoom ratio
  # @option [Float] :fit_width Fit width to <fp> pixels
  # @option [Float] :fit_height Fit height to <fp> pixels
  # @option [Boolean, Integer] :use_cropbo (default: true) Use CropBox instead of MediaBox
  # @option [Float] :hdpi (default: 144) Horizontal resolution for graphics in DPI
  # @option [Float] :vdpi (default: 144) Vertical resolution for graphics in DPI
  # @option [String] :embed Specify which elements should be embedded into output
  # @option [Boolean, Integer] :embed_css (default: true) Embed CSS files into output
  # @option [Boolean, Integer] :embed_font (default: true) Embed font files into output
  # @option [Boolean, Integer] :embed_image (default: true) Embed image files into output
  # @option [Boolean, Integer] :embed_javascript (default: true) Embed JavaScript files into output
  # @option [Boolean, Integer] :embed_outline (default: true) Embed outlines into output
  # @option [Boolean, Integer] :split_pages (default: false) Split pages into separate files
  # @option [String] :dest_dir (default: ".") Specify destination directory
  # @option [String] :css_filename (default: "") Filename of the generated css file
  # @option [String] :page_filename (default: "") Filename template for split pages
  # @option [String] :outline_filename (default: "") Filename of the generated outline file
  # @option [Boolean, Integer] :process_nontext (default: true) Render graphics in addition to text
  # @option [Boolean, Integer] :process_outline (default: true) Show outline in HTML
  # @option [Boolean, Integer] :process_annotation (default: false) Show annotation in HTML
  # @option [Boolean, Integer] :process_form (default: false) Include text fields and radio buttons
  # @option [Boolean, Integer] :printing (default: true) Enable printing support
  # @option [Boolean, Integer] :fallback (default: false) Output in fallback mode
  # @option [Integer] :tmp_file_size_limit (default: -1) Maximum size (in KB) used by temporary files, -1 for no limit.
  # @option [Boolean, Integer] :embed_external_font (default: true) Embed local match for external fonts
  # @option [String] :font_format (default: "woff") Suffix for embedded font files (ttf,otf,woff,svg)
  # @option [Boolean, Integer] :decompose_ligature (default: false) Decompose ligatures, such as ﬁ -> fi
  # @option [Boolean, Integer] :auto_hint (default: false) Use fontforge autohint on fonts without hints
  # @option [String] :external_hint_tool (default: "") External tool for hinting fonts (overrides --auto-hint)
  # @option [Boolean, Integer] :stretch_narrow_glyph (default: false) Stretch narrow glyphs instead of padding them
  # @option [Boolean, Integer] :squeeze_wide_glyph (default: true) Shrink wide glyphs instead of truncating them
  # @option [Boolean, Integer] :override_fstype (default: false) Clear the fstype bits in TTF/OTF fonts
  # @option [Boolean, Integer] :process_type3 (default: false) Convert Type 3 fonts for web (experimental)
  # @option [Float] :heps (default: 1) Horizontal threshold for merging text, in pixels
  # @option [Float] :veps (default: 1) Vertical threshold for merging text, in pixels
  # @option [Float] :space_threshold(default: 0.125)  Word break threshold (threshold * em)
  # @option [Integer] :font_size_multiplier (default: 4) A value greater than 1 increases the rendering accuracy
  # @option [Boolean, Integer] :space_as_offset (default: false) Treat space characters as offsets
  # @option [Integer] :tounicode (default: 0) How to handle ToUnicode CMaps (0=auto, 1=force, -1=ignore)
  # @option [Boolean, Integer] :optimize_text (default: false) Try to reduce the number of HTML elements used for text
  # @option [Boolean, Integer] :correct_text_visibility (default: false) Try to detect texts covered by other graphics and properly arrange them
  # @option [String] :bg_format (default: "png") Specify background image format
  # @option [Integer] :svg_node_count_limit (default: -1) if node count in a svg background image exceeds this limit, fall back this page to bitmap background; negative value means no limit
  # @option [Boolean, Integer] :svg_embed_bitmap (default: true) True: embed bitmaps in svg background; False: dump bitmaps to external files if possible.
  # @option [String] :owner_password Owner password (for encrypted files)
  # @option [String] :user_password User password (for encrypted files)
  # @option [Boolean, Integer] :no_drm (default: false) Override document DRM settings
  # @option [Boolean, Integer] :clean_tmp (default: true) Remove temporary files after conversion
  # @option [String] :tmp_dir (default: "/var/folders/rn/1xx0_xsd089fldtvtnq1tk7m0000gn/T/") Specify the location of temporary directory
  # @option [String] :data_dir (default: "/usr/local/Cellar/pdf2htmlex/0.14.6_24/share/pdf2htmlEX") Specify data directory
  # @option [Boolean, Integer] :debug (default: false) Print debugging information
  # @option [Boolean, Integer] :proof (default: false) Exts are drawn on both text layer and background for proof.
  # @raise [Pdf2htmlex::Error] catch errors from pdf2htmlEX into Pdf2htmlex::Error exception
  # @return [Pathname] The generated HTML file
  def convert(input_pdf, html_filename = nil, **options)
    options[:dest_dir] ||= make_tempdir

    output = output_html(options[:dest_dir], html_filename || input_pdf)
    command = normalize_options(options)
    command << input_pdf
    command << output.basename.to_s

    run_command(command)

    output
  end

  private

  def make_tempdir
    Dir.mktmpdir
  end

  # Generate a unique HTML filename within destination directory
  # @param base_dir [String] The directory path
  # @param target_filename [String] the
  def output_html(base_dir, target_filename)
    basename = File.basename(target_filename).sub(%r{\.(pdf|htm|html)$}i, '')
    filename = File.join(base_dir, format('%<fname>s.html', fname: basename))
    n = 0
    while File.exist?(filename)
      n += 1
      filename = File.join(base_dir, format('%<fname>s.%<fnum>d.html', fname: basename, fnum: n))
    end
    Pathname.new(filename)
  end

  def normalize_options(opts)
    [].tap do |arr|
      opts.each do |k, v|
        next if v.nil?
        next unless CMD_OPTIONS.key?(k)

        arr << CMD_OPTIONS[k] << cast_value(v)
      end
    end
  end

  def cast_value(value)
    case value
    when Proc then cast_value(value.call)
    when TrueClass then '1'
    when FalseClass then '0'
    else
      value
    end
  end

  def run_command(command, input = nil)
    opts = { binmode: true, stdin_data: input }

    command.unshift config.executable

    output, error, status = Open3.capture3(*command, opts)

    if status.exitstatus != 0
      raise Error, "pdf2htmlEX failed with: #{error}\nCommand: #{command.join(' ')}"
    end

    output
  end
end
