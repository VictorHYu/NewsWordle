require 'magic_cloud'

words = [ ["hello", 50], ["my",20], ["name",30], ["is", 40], ["victor", 50]]
cloud = MagicCloud::Cloud.new(words, palette: :category20, rotate: :square)
img = cloud.draw(1000,1000)

img.write("./output.jpg")
