require 'rspec/expectations'
require 'color'

RED = Color::RGB.by_hex('#ED4B35')
GREEN = Color::RGB.by_hex('#11C560')
AMBER = Color::RGB.by_hex('#F5A623')
BROWN = Color::RGB.by_hex('#8B572A')
BLUE = Color::RGB.by_hex('#4A90E2')
GRAY = Color::RGB.by_hex('#9B9B9B')
PALETTE = [RED, GREEN, AMBER, BROWN, BLUE, GRAY].freeze

RSpec::Matchers.define :be_greyscale do
  match do |actual|
    actual.to_grayscale.to_rgb.closest_match(PALETTE + [actual], 5) == actual
  end
end

module Colors
  def foreground_color(element)
    by_rgb(computed_style(element, 'color'))
  end

  def foreground_palette(element)
    foreground_color(element).closest_match(PALETTE)
  end

  def background_color(element)
    by_rgb(computed_style(element, 'backgroundColor'))
  end

  def background_palette(element)
    background_color(element).closest_match(PALETTE)
  end

  def computed_style(node, attribute)
    page.evaluate_script("window.getComputedStyle(document.evaluate('#{node.path}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue).#{attribute}")
  end

  def by_rgb(rgb)
    /rgb\((\d+),\s*(\d+),\s*(\d+)\)/.match(rgb) do |m|
      Color::RGB.new(m[1].to_i, m[2].to_i, m[3].to_i)
    end
  end
end
