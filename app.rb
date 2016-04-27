require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'leprosorium.db'
  @db.results_as_hash = true
end

before do
  init_db
end

configure do
  init_db
  @db.execute 'CREATE TABLE IF NOT EXISTS Posts
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_date DATE,
      content TEXT
    )'
end

get '/' do
  @results = @db.execute 'SELECT * FROM POSTS ORDER BY id DESC'

	erb :index
end

get '/NewPost' do
  erb :NewPost
end

post '/NewPost' do
  content = params[:content]

  if content.length == 0
    @error = "Type post text"
    return erb :NewPost
  end

  @db.execute 'INSERT INTO Posts (content, created_date) VALUES (?, datetime())', [content]

  #После добавления каждого нового поста перенаправление на главную

  redirect to '/'

end

get '/details/:post_id' do
  post_id = params[:post_id]

  erb "Some information about post #{post_id}"
end
