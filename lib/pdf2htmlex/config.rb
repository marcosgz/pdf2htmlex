# frizen_string_literal: true

module Pdf2htmlex
  CMD_OPTIONS = {
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
  }

  Config = Struct.new(:executable)

  def config
    @config ||= Config.new('pdf2htmlex')
  end
end
