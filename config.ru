require './capsules'
set :public_folder, File.join(APP_ROOT, "public")
run Sinatra::Application
