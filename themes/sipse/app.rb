# encoding: UTF-8
# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.
require 'rubygems'
require 'compass'
require 'sinatra'
require 'haml'

module Nesta
  class App
    configure do
      Compass.configuration do |config|
        config.project_path = File.dirname(__FILE__)
        config.sass_dir = 'views'
        config.environment = :development
        config.relative_assets = true
        config.http_path = "/"
      end
      set :haml, { :format => :html5 }
      set :sass, Compass.sass_engine_options
    end

    get '/css/:sheet.css' do
      content_type 'text/css', :charset => 'utf-8'
      cache sass(params[:sheet].to_sym)
    end

    get 'contacto' do
      haml :contacto
    end

    post '/contacto' do
      require 'pony'
      message = ""
      params.each_pair do |key, value|
        message << "#{key}: #{value}\n"
      end
      puts message
      Pony.mail(
        :from => params[:nombre] + "<" + params[:email] + ">",
        :to => "info@sipsemx.com",
        :subject => "Forma de contacto",
        :body => message,
        :port => '587',
        :via => :smtp,
        :via_options => {
          :address => "smtp.sendgrid.net",
          :port => '587',
          :user_name => ENV['SENDGRID_USERNAME'],
          :password => ENV['SENDGRID_PASSWORD'],
          :authentication => :plain,
          :domain => ENV['SENDGRID_DOMAIN']
        }
      )
      Pony.mail(
        :from => "SIPSE <info@sipsemx.com>",
        :to => params[:email],
        :subject => "Respuesta de SIPSE",
        :body => "Agradecemos mucho su interés en SIPSE. En breve recibirá una respuesta por parte de uno de nuestros ejecutivos. www.sipsemx.com",
        :port => '587',
        :via => :smtp,
        :via_options => {
          :address => "smtp.sendgrid.net",
          :port => '587',
          :user_name => ENV['SENDGRID_USERNAME'],
          :password => ENV['SENDGRID_PASSWORD'],
          :authentication => :plain,
          :domain => ENV['SENDGRID_DOMAIN']
        }
      )
      redirect '/success'
    end

    get 'success' do
      haml :success
    end

    # Uncomment the Rack::Static line below if your theme has assets
    # (i.e images or JavaScript).
    #
    # Put your assets in themes/sipse/public/sipse.
    #
    use Rack::Static, :urls => ["/sipse"], :root => "themes/sipse/public"

    helpers do
      # Add new helpers here.
    end

    # Add new routes here.
  end
end
