require 'sinatra'
require 'sinatra/contrib'
require_relative 'models/line'

enable :sessions

get '/story' do
  getCurrentLines
  erb :index
end

get '/:line' do #when one of the user added links/back to the start are clicked
 session["startline"] = session["story"].detect { |l| l.storyline == params[:line]} 
 getCurrentLines
 erb :index
end

get '/' do
  session["story"] = [Line.new(0, "centre", "Once upon a time, there was a big bad wolf.")]
  session["startline"] = session["story"].first
  getCurrentLines
  erb :index
end

post '/newline' do
  session["story"] <<  Line.new(session["startline"].id, params["pos"], params["line"])
  redirect '/story'
end 

#get array of lines with parent id equal to current centre line
def getCurrentLines
  session["currentpage"] = session['story'].select do |line|
    line.parent_id == session["startline"].id
  end  
  session["currentpage"]
end  