require 'sinatra/base'
require 'sinatra/config_file'
require 'base64'


class Application < Sinatra::Base
  register Sinatra::ConfigFile

  config_file 'config/config.yml'

  before do
    log_parameters
    @upload_dir = File.expand_path("#{settings.upload_dir}")
    Dir.mkdir(@upload_dir) unless File.directory?(@upload_dir)
  end

  get '/' do
    erb :index
  end

  post '/ajax-upload' do
    data = params[:data]
    filename = "#{Time.now.to_i}_#{params[:filename]}"
    validate_file_extension(params[:filename])

    data_index = data.index('base64') + 7
    filedata = data.slice(data_index, data.length)
    decoded_image = Base64.decode64(filedata)

    file = File.open("#{@upload_dir}/#{filename}", "w+") { |f| f.write(decoded_image) }
    "#{@upload_dir}/#{filename}"
  end

  helpers do
    def validate_file_extension(file)
      ext = File.extname(file)[1..-1]
      halt(415, "#{file} не изображение") unless settings.accepted_file_types.include?(ext)
    end
  end

  private

  def log_parameters
    puts "[filename] #{params[:filename]} \n"
  end

end
