# README

1. install bcrypt and jwt 
2. create user model and migration
    - user will have a password_digest column instead of password column 
    - model will have has_secure_password (from bcrypt)
    - has_secure_password will take password and password_confirmation (optional) and process it to put password_digest in the backend
3. in user controller:
    1. create: get user params from frontend, use jwt to encode user id, return user and token to frontend
    2. login: find user by username, check if it exists and the password for user is authentic, use jwt to encode user id, send user and token to frontend
    3. logout: set global current user to nil
    4. show (/me): return global current_user
    5. only authorize before show
4. in application controller:
    1. check if authorized/logged in: get token from headers, check of jwt decodable, decode token to get user_id, find user by id in database
    2. rescue deny acces, record errors, not found errors 
    3. before all actions make sure to authorize
    4. skip verify_authenticity_token for csrf stuff
    5. make helper methods: encode_token
5. in routes:
    1. create get for check if already logged in
    2. create post for new user
    3. create post for user logging in
    4. create post for user logging out
6. in frontend:
    1. create signup and login as controlled forms
    2. when component first mounts fetch for auto login authorization: check if localstorage contains jwt token, if so send to backend, on success set current user
    3. on login submit: post logindata to api, on success set localstorage 'jwt' to received token, setuser to current user
    4. on logout: fetch post backend to clear anything, clear localstorage at 'jwt', clear current user state

 def logged_in_user
    if decoded_token 
        user_id = decoded_token[0]['user_id']
        @current_user = User.find_by(id: user_id)
    end 
end

def login 
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        end 
    end 



has_secure_password: in model, creates password_digest from password param

CSRF: made for classical web apps, makes sure requests coming from same server...use
protect_from_forgery with: :null_session
to override

JWT: use token = encode_token({user_id: @user.id}) and JWT.decode(token, 'secret', true, algorithm: 'HS256')

request.headers

user.authenticate - built in method from rails that checks given password against password_digest



## Login
1. fetch post /login and pass in username, password
2. check if username exists
3. use has_secure_password's authenticate to check password against password_digets
4. if all is good encode new token based off user_id
5. render json for user and token

## Logout
1. fetch post /logout
2. clear current user
3. clear token 

## Signup
1. fetch post /signup with credentials
2. create new user 
3. encode token based of user id 
4. render json user and token 

## Auto login
1. fetch post /me on component load with token 
2. check if auth header exists
3. decode token if exists to get user id 
4. find user by user id and set to current user
5. render json: user

