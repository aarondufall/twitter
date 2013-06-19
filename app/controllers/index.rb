get '/' do
  if session[:user]
    erb :tweet
  else
    erb :index
  end
end

get '/sign_in' do 
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # p @access_token


  # at this point in the code is where you'll need to create your user account and store the access token
  username = @access_token.params[:screen_name]
  user_id = @access_token.params[:user_id]
  token = @access_token.token 
  secret =  @access_token.secret
  @user = User.find_or_create_by_user_id(user_id: user_id, username: username, oauth_token: token, oauth_secret: secret)
  session[:user] = @user.id
  redirect to '/tweet'
end

get '/tweet' do
  if session[:user]
    erb :tweet
  else
    redirect '/'
  end
end

post '/tweet' do
  job_id = current_user.tweet_in(10, params[:status])
  if request.xhr?
    {jobId: job_id}.to_json
  else
    erb :tweet
  end
end


get '/status/:job_id' do
  job_status = job_is_complete(params[:job_id])
  {jobStatus: job_status}.to_json
end


     # t.string :username
     #    t.string :oauth_token
     #    t.string :oauth_secret
