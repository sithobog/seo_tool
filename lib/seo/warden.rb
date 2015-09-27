Warden::Strategies.add(:password) do

  def valid?
    params['username'] && params['password']
  end

  
  def authenticate!
    array = Seo::User.get_by_name(params['username'])
    if array.empty?
      throw(:warden, message: 'Could not login with this credentials')
    else
      user = Seo::User.new(array[0][:id],array[0][:username],array[0][:password],array[0][:user_ip])
    end
    if user.authenticate(params['password'])
      success!(user, 'Successfully logged in')
    end
  end

end
