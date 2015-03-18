require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'

DataMapper::setup(:default,"sqlite3://#{Dir.pwd}/db/adserver.db")

class Ad

  include DataMapper::Resource

  property :id,           Serial
  property :title,        String
  property :content,      Text
  property :width,        Integer
  property :height,       Integer
  property :filename,     String
  property :url,          String
  property :is_active,    Boolean
  property :created_at,   DateTime
  property :updated_at,   DateTime
  property :size,         Integer
  property :content_type, String
end

DataMapper::Model.raise_on_save_failure = true
DataMapper.auto_upgrade!

get "/" do
  @page_title="default page"
  erb :landing_page
end
get "/new" do
  @page_title="Create a New Ad"
  erb :new
end

post "/create" do
  ad = Ad.new(params[:ad])
  ad.content_type = params[:image][:type]
  ad.size = File.size(params[:image][:tempfile])
  ad.filename = params[:image][:filename]
  if ad.save
    upload_file = params[:image][:tempfile];
    path_to_save = File.join(Dir.pwd, "/public/ads",ad.filename);
    File.open(path_to_save,"wb") do |f|
      f.write(upload_file.read)
    end
    redirect("/show/#{ad.id}");
  else
    redirect('/list');
  end
end

get "show/:id" do
end

get "/ad" do
end
get "/list" do
end
get "delete/:id" do
end
get "click/:id" do
end

