require 'rubygems'
require 'sinatra'
require 'flickraw'
require 'config.rb'

FlickRaw.api_key = FLICKR_API_KEY

module FlickRaw
  # extending flickraw to make a URL helper for photosets
  def self.photosets_url_s(r)
    PHOTO_SOURCE_URL % [r.farm, r.server, r.primary, r.secret, "_s", "jpg"]
  end

  def self.photosets_url_m(r)
    PHOTO_SOURCE_URL % [r.farm, r.server, r.primary, r.secret, "_m", "jpg"]
  end
end

get '/' do
  @photosets = flickr.photosets.getList(:user_id => FLICKR_USER_ID)
  haml :photosets
end

get '/user/:id' do
  @user = flickr.people.findByUsername(:username => params[:id])
  @photosets = flickr.photosets.getList(:user_id => @user.id)
  haml :photosets
end

# this section needs to get DRYer

get '/photoset/:id' do
  raise not_found if params[:id].nil?
  @photoset = flickr.photosets.getPhotos(:photoset_id => params[:id])
  @info = flickr.photosets.getInfo(:photoset_id => params[:id])
  haml :photos
end

get '/photoset-big/:id' do
  raise not_found if params[:id].nil?
  @photoset = flickr.photosets.getPhotos(:photoset_id => params[:id])
  @info = flickr.photosets.getInfo(:photoset_id => params[:id])
  haml :photosbig
end

get '/photoset-huge/:id' do
  raise not_found if params[:id].nil?
  @photoset = flickr.photosets.getPhotos(:photoset_id => params[:id])
  @info = flickr.photosets.getInfo(:photoset_id => params[:id])
  haml :photoshuge
end

get '/photo/:id' do
  @photo = flickr.photos.getInfo(:photo_id => params[:id])
  @exif = flickr.photos.getExif(:photo_id => params[:id])["exif"]
  
  @exposure = exif_comprehend(@exif, "ExposureTime")
  @aperture = exif_comprehend(@exif, "FNumber")
  @iso = exif_comprehend(@exif, "ISO")
  @focal_length = exif_comprehend(@exif, "FocalLengthIn35mmFormat")
  @make = exif_comprehend(@exif, "Make")
  @model = exif_comprehend(@exif, "Model")
  haml :photo
end

# http://stackoverflow.com/questions/310426/list-comprehension-in-ruby
class Array
  def comprehend(&block)
    return self if block.nil?
    self.collect(&block).compact
  end
end

def exif_comprehend(exif_full, tag)
  # finds the specific EXIF data you're looking for
  single_row = exif_full.comprehend {|x| x if x["tag"] == tag}
  if single_row[0] == nil
    # dealing with nils: return nothing if the record is nil.  Do not remove [0] or it won't work properly 
  else
    single_row[0]["raw"]
  end
end