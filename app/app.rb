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
    @prefectures = %w|北海道 青森県 岩手県 宮城県 秋田県 山形県 福島県 茨城県 栃木県 群馬県 埼玉県 千葉県 東京都 神奈川県 新潟県 富山県 石川県 福井県 山梨県 長野県 岐阜県 静岡県 愛知県 三重県 滋賀県 京都府 大阪府 兵庫県 奈良県 和歌山県 鳥取県 島根県 岡山県 広島県 山口県 徳島県 香川県 愛媛県 高知県 福岡県 佐賀県 長崎県 熊本県 大分県 宮崎県 鹿児島県 沖縄県|
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

  get %r{/api(.jQuery)?(.noConflict)?.js} do |jQuery, noConflict|
    scheme =  request.env['rack.url_scheme']
    host =  request.env['HTTP_HOST']
    content_type 'text/javascript'
    body = ""
    if jQuery
      body += File.read(Padrino.root + '/public/javascripts/jquery.js')
      if noConflict
        body += "\n\n" + "jQuery.noConflict();\n\n"
      end
    end
    body += "var postal_base_url = \"BASE_URL\";\n\n".gsub(/BASE_URL/, "#{scheme}://#{host}/")
    body += File.read(Padrino.root + '/public/javascripts/jquery.postal.js')
  end
end
