module ApplicationHelper
  def embedded_svg(filename, options = {})
    assets = (Rails.application.assets || ::Sprockets::Railtie.build_environment(Rails.application))
    file = assets.find_asset(filename).source.force_encoding("UTF-8")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css "svg"
    if options.key?(:class)
      svg["class"] = options.fetch(:class)
    end
    options.fetch(:data, {}).each do |key, value|
      svg["data-#{key}"] = value
    end
    raw doc
  end
end
