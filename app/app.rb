class Postal2 < Padrino::Application
  register SassInitializer
  register Padrino::Mailer
  register Padrino::Helpers

  ##
  # Application configuration options
  #
  # set :raise_errors, true     # Show exceptions (default for development)
  # set :public, "foo/bar"      # Location for static assets (default root/public)
  # set :reload, false          # Reload application files (default in development)
  # set :default_builder, "foo" # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"     # Set path for I18n translations (defaults to app/locale/)
  # enable  :sessions           # Disabled by default
  # disable :flash              # Disables rack-flash (enabled by default if sessions)
  # layout  :my_layout          # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  #

  set :haml, {:format => :html5}

  ##
  # You can configure for a specified environment like:
  #
  #   configure :development do
  #     set :foo, :bar
  #     disable :asset_stamp # no asset timestamping for dev
  #   end
  #

  ##
  # You can manage errors like:
  #
  #   error 404 do
  #     render 'errors/404'
  #   end
  #

  get :index do
    haml :index
  end

  get :demo do
    haml :demo
  end

  get '/api', :with => :zipcode do
    json = Postal.where(:zipcode => /^#{params[:zipcode]}/).limit(100).entries.to_json
    if params['callback']
      params['callback'] + '(' + json + ');'
    else
      json
    end
  end

  get '/api.js' do
    scheme =  request.env['rack.url_scheme']
    host =  request.env['HTTP_HOST']
    content_type 'text/javascript'
    body = ""
    unless params['nojquery']
      body += File.read(Padrino.root + '/public/javascripts/jquery.js')
      body += "\n\n" + "jQuery.noConflict();\n\n"
    end
    body += "var postal_base_url = \"BASE_URL\";\n\n".gsub(/BASE_URL/, "#{scheme}://#{host}/")
    body += File.read(Padrino.root + '/public/javascripts/jquery.postal.js')
  end
end
