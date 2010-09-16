class Array
  def comprehend(&block)
    return self if block.nil?
    self.collect(&block).compact
  end
end

lol = {"farm"=>5, "server"=>"4131", "id"=>"4974510071", "exif"=>[{"label"=>"FileName", "tagspaceid"=>0, "tagspace"=>"System", "tag"=>"FileName", "raw"=>"ORI3664088602933814124.img"}, {"label"=>"Directory", "tagspaceid"=>0, "tagspace"=>"System", "tag"=>"Directory", "raw"=>"/home/y/tmp/8"}]}

exif_compressed = lol["exif"].comprehend {|x| x if x["label"] == "Directory"}

puts exif_compressed
