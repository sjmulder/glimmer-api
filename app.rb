require 'sinatra'
require 'sinatra/activerecord'

configure :development do
  API_KEY = ENV['API_KEY'] || '**DEV**'

  set :database, 'sqlite:///db/glimmer.db'
  set :show_exceptions, true
end

configure :production do
  API_KEY = ENV['API_KEY']

  db = URI.parse(ENV['DATABASE_URI'] || 'postgres:///localhost/glimmer')
  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgress' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end

class App < ActiveRecord::Base
  has_many :releases, :dependent => :destroy

  validates_presence_of :slug
  validates_format_of   :slug, :with => /\A[a-z][a-z\-_]*\Z/

  def url(base_url)
    "#{base_url}/apps/#{slug}"
  end

  def feed_url(base_url)
    "#{url(base_url)}.rss"
  end
end

class Release < ActiveRecord::Base
  belongs_to :app

  validates_presence_of :app_id
  validates_presence_of :version
  validates_presence_of :bundle_identifier
  validates_presence_of :package_url

  scope :sorted, lambda { order('version desc') }

  def url(base_url)
    "#{base_url}/apps/#{app.slug}/#{version}"
  end

  def manifest_url(base_url)
    "#{url(base_url)}/manifest.plist"
  end

  def release_notes_url(base_url)
    "#{url(base_url)}/release-notes.html"
  end

  def display_version
    version_string || version
  end

  def full_title
    "#{app.title} #{display_version}"
  end
end

get '/apps/:slug.rss' do
  @app = App.find_by!(:slug => params[:slug])
  @releases = @app.releases.sorted
  @base_url = request.base_url

  builder :feed
end

get '/apps/:slug/:version/manifest.plist' do
  @app = App.find_by!(:slug => params[:slug])
  @release = @app.releases.find_by!(:version => params[:version])
  builder :ipa_manifest
end

get '/apps/:slug/:version/release-notes.html' do
  app = App.find_by!(:slug => params[:slug])
  @release = app.releases.find_by!(:version => params[:version])
  return 404 if @release.release_notes_html.nil?

  erb :release_notes
end

put '/apps/:slug/:version' do
  return 403 if API_KEY.nil? || params[:api_key] != API_KEY

  app = App.find_by(:slug => params[:slug]) || App.new
  app.slug  = params[:slug]
  app.title = params[:app_title]
  app.save!

  release = app.releases.find_by(:version => params[:version]) || Release.new
  release.app                 = app
  release.version             = params[:version].to_i
  release.version_string      = params[:version_string]
  release.bundle_identifier   = params[:bundle_identifier]
  release.package_url         = params[:package_url]
  release.icon_url            = params[:icon_url]
  release.icon_needs_shine    = !!params[:icon_needs_shine].to_i
  release.artwork_url         = params[:artwork_url]
  release.artwork_needs_shine = !!params[:artwork_needs_shine].to_i
  release.release_notes_html  = params[:release_notes_html]
  release.save!
end

delete '/apps/:slug/:version' do
  return 403 if API_KEY.nil? || params[:api_key] != API_KEY

  app = App.find_by(:slug => params[:slug])
  return 200 if app.nil?

  release = app.releases.find_by(:version => params[:version])
  release.destroy! unless @release.nil?

  app.releases.reload
  app.destroy! if app.releases.empty?
end

error ActiveRecord::RecordNotFound do
  404
end

error ActiveRecord::RecordInvalid do
  [400, {}, env['sinatra.error'].message + "\n"]
end
