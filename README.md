# Ruby wrapper for pdf2htmlEX

`pdf2htmlEX` converts PDF to HTML while retaining text, format and style as much as possible by making use of HTML5, JavaScript and modern CSS features. Even difficult content like PDFs with embedded fonts, multicolumn documents, scientific papers with complicated figures and mathematical formulas will mostly be represented correctly. Fallback mode generates HTML pages which do not require any JavaScript to view them correctly at the expense of a larger file size.

## Installation

You will need `pdf2htmlEX` installed. If you are using Mac OS X, I recommend installing pdf2htmlEX with Homebrew by running the following:

    $ brew install pdf2htmlex

If you are using Debian, you can install the pdf2htmlex package like so:

    $ apt install pdf2htmlex

If you've docker env setup, just install it via docker:

    $ alias pdf2htmlex="docker run -ti --rm -v ~/pdf:/tmp/pdf iapain/pdf2htmlex pdf2htmlEX"

After that just add this line to your application's Gemfile:

```ruby
gem 'pdf2htmlex'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pdf2htmlex

## Usage

Configuration:

```ruby
require 'pdf2htmlex'

Pdf2htmlex.config.executable = '/usr/local/bin/pdf2htmlEX' # Default value: 'pdf2htmlex'
```

To convert files use the `Pdf2htmlex::convert` method with the PDF file as the first argument, optional output filename as the second argument and list of options. Example:

```ruby
2.7.0 (main):0 > output = Pdf2htmlex.convert('./example/demo1.pdf')
=> #<Pathname:/var/folders/rn/1xx0_xsd089fldtvtnq1tk7m0000gn/T/d20210409-96258-1pmrw5z/demo1.html>
2.7.0 (main):0 > output = Pdf2htmlex.convert('./example/demo1.pdf', 'sample.html')
=> #<Pathname:/var/folders/rn/1xx0_xsd089fldtvtnq1tk7m0000gn/T/d20210409-96258-14l7p6u/sample.html>
2.7.0 (main):0 > output = Pdf2htmlex.convert('./example/demo1.pdf', 'demo.html', dest_dir: '/tmp')
=> #<Pathname:/tmp/demo.html>
```

All options:
```bash
first_page: '--first-page',                           # first page to convert (default: 1)
last_page: '--last-page',                             # last page to convert (default: 2147483647)
zoom: '--zoom',                                       # zoom ratio
fit_width: '--fit-width',                             # fit width to <fp> pixels
fit_height: '--fit-height',                           # fit height to <fp> pixels
use_cropbox: '--use-cropbox',                         # use CropBox instead of MediaBox (default: 1)
hdpi: '--hdpi',                                       # horizontal resolution for graphics in DPI (default: 144)
vdpi: '--vdpi',                                       # vertical resolution for graphics in DPI (default: 144)
embed: '--embed',                                     # specify which elements should be embedded into output
embed_css: '--embed-css',                             # embed CSS files into output (default: 1)
embed_font: '--embed-font',                           # embed font files into output (default: 1)
embed_image: '--embed-image',                         # embed image files into output (default: 1)
embed_javascript: '--embed-javascript',               # embed JavaScript files into output (default: 1)
embed_outline: '--embed-outline',                     # embed outlines into output (default: 1)
split_pages: '--split-pages',                         # split pages into separate files (default: 0)
dest_dir: '--dest-dir',                               # specify destination directory (default: ".")
css_filename: '--css-filename',                       # filename of the generated css file (default: "")
page_filename: '--page-filename',                     # filename template for split pages  (default: "")
outline_filename: '--outline-filename',               # filename of the generated outline file (default: "")
process_nontext: '--process-nontext',                 # render graphics in addition to text (default: 1)
process_outline: '--process-outline',                 # show outline in HTML (default: 1)
process_annotation: '--process-annotation',           # show annotation in HTML (default: 0)
process_form: '--process-form',                       # include text fields and radio buttons (default: 0)
printing: '--printing',                               # enable printing support (default: 1)
fallback: '--fallback',                               # output in fallback mode (default: 0)
tmp_file_size_limit: '--tmp-file-size-limit',         # Maximum size (in KB) used by temporary files, -1 for no limit. (default: -1)
embed_external_font: '--embed-external-font',         # embed local match for external fonts (default: 1)
font_format: '--font-format',                         # suffix for embedded font files (ttf,otf,woff,svg) (default: "woff")
decompose_ligature: '--decompose-ligature',           # decompose ligatures, such as ﬁ -> fi (default: 0)
auto_hint: '--auto-hint',                             # use fontforge autohint on fonts without hints (default: 0)
external_hint_tool: '--external-hint-tool',           # external tool for hinting fonts (overrides --auto-hint) (default: "")
stretch_narrow_glyph: '--stretch-narrow-glyph',       # stretch narrow glyphs instead of padding them (default: 0)
squeeze_wide_glyph: '--squeeze-wide-glyph',           # shrink wide glyphs instead of truncating them (default: 1)
override_fstype: '--override-fstype',                 # clear the fstype bits in TTF/OTF fonts (default: 0)
process_type3: '--process-type3',                     # convert Type 3 fonts for web (experimental) (default: 0)
heps: '--heps',                                       # horizontal threshold for merging text, in pixels (default: 1)
veps: '--veps',                                       # vertical threshold for merging text, in pixels (default: 1)
space_threshold: '--space-threshold',                 # word break threshold (threshold * em) (default: 0.125)
font_size_multiplier: '--font-size-multiplier',       # a value greater than 1 increases the rendering accuracy (default: 4)
space_as_offset: '--space-as-offset',                 # treat space characters as offsets (default: 0)
tounicode: '--tounicode',                             # how to handle ToUnicode CMaps (0=auto, 1=force, -1=ignore) (default: 0)
optimize_text: '--optimize-text',                     # try to reduce the number of HTML elements used for text (default: 0)
correct_text_visibility: '--correct-text-visibility', # try to detect texts covered by other graphics and properly arrange them (default: 0)
bg_format: '--bg-format',                             # specify background image format (default: "png")
svg_node_count_limit: '--svg-node-count-limit',       # if node count in a svg background image exceeds this limit, fall back this page to bitmap background; negative value means no limit. (default: -1)
svg_embed_bitmap: '--svg-embed-bitmap',               # 1: embed bitmaps in svg background; 0: dump bitmaps to external files if possible. (default: 1)
owner_password: '--owner-password',                   # owner password (for encrypted files)
user_password: '--user-password',                     # user password (for encrypted files)
no_drm: '--no-drm',                                   # override document DRM settings (default: 0)
clean_tmp: '--clean-tmp',                             # remove temporary files after conversion (default: 1)
tmp_dir: '--tmp-dir',                                 # specify the location of temporary directory. (default: "/var/folders/rn/1xx0_xsd089fldtvtnq1tk7m0000gn/T/")
data_dir: '--data-dir',                               # specify data directory (default: "/usr/local/Cellar/pdf2htmlex/0.14.6_24/share/pdf2htmlEX")
debug: '--debug',                                     # print debugging information (default: 0)
proof: '--proof',                                     # texts are drawn on both text layer and background for proof. (default: 0)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcosgz/pdf2htmlex.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
