module Graspi
  module AssetsIncludeHelper

    def graspi_stylesheet_link_tag(name)
      "<style></style>".html_safe
    end

    def graspi_javascript_include_tag(name)
      "<script></script>".html_safe
    end

  end
end