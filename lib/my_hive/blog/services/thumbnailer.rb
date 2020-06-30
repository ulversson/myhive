require 'link_thumbnailer'

result = LinkThumbnailer.generate(ARGV[0])
puts result.images[0].src
puts result.title
puts result.description