module Graspi
  module AssetsIncludeHelper

    def graspi_stylesheet_link_tag(*sources)
      options = sources.extract_options!.stringify_keys

      sources.uniq.map { |source|
        tag_options = {
          "rel" => "stylesheet",
          "media" => "screen",
          "href" => graspi_file_path("#{source}.css")
        }.merge!(options)
        tag(:link, tag_options)
      }.join("\n").html_safe
    end

    def graspi_javascript_include_tag(*sources)
      options = sources.extract_options!.stringify_keys

      sources.uniq.map { |source|
        tag_options = {
          "src" => graspi_file_path("#{source}.js")
        }.merge!(options)
        content_tag(:script, "", tag_options)
      }.join("\n").html_safe
    end

    def graspi_image_url(path)
      graspi_file_path(path)
    end

    def graspi_image_tag(path, options = {})
      tag_options = options.merge({ src: graspi_file_path(path) })

      tag(:img, tag_options)
    end

    def graspi_file_path(path)
      mapping = Graspi.manifest(Rails.env)

      mapping[path]
    end

  end
end