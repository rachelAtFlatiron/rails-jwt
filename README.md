# README
## Notes

- MAKE SURE TO INSTALL bcrypt (for password_digest and rails authentication) and JWT (for tokens on frontend)
- has_secure_password: in model, creates password_digest from password param
- user.authenticate - built in method from rails that checks given password against password_digest
- CSRF: made for classical web apps, makes sure requests coming from same server...use protect_from_forgery with: :null_session to override
- SECRET_KEY: secret key used to encrypt JWT token, should be stored securely in credentials.yml.enc (which isn't pushed to github)
- JWT: uses token to encode user id info in front end cookies; use the following: encode_token({user_id: @user.id}) and JWT.decode(token, 'secret', true, algorithm: 'HS256')
- request.headers to send in authorization header in format: { Authorization: 'Bearer <token>' }

## Login

1. fetch post /login and with body {username, password}
2. check if username exists in database
3. use has_secure_password's authenticate to check password against password_digest
4. if all is good encode new token based off user_id: JWT.encode({user_id: @user.id}, SECRET_KEY) 
5. render json for user and token
6. set localStorage 'jwt' token on front end
7. set user state on front end

## Logout

1. fetch post /logout
2. clear current user on back end if applicable
3. clear current user on front end
4. clear token on front end

## Signup

1. fetch post /signup and with body {username, password, email, etc.}
2. in rails - create new user with user_params (has_secure_password will convert password to password_digest)
3. encode token based off user id: JWT.encode({user_id: @user.id}, SECRET_KEY) 
4. render json user and token
5. set token on front end 
6. set user state on front end

## Auto login

1. fetch post /me on component load and pass in authorization header with token like so: headers: { "Authorization": `Bearer ${token}`}
2. in rails - check if auth header and token exists
3. decode token if exists to get user id with the following: JWT.decode(token, 'secret', true, algorithm: 'HS256')
4. find user by user id from decoded token and set to @current_user
5. render json: user
6. set user state on front end

## Front End

1. login, signup, logout buttons/CONTROLLED forms
2. create state for current user
3. auto login on component mount (useEffect) fetches /me
4. on login fetch /login, on signup fetch /logout, on logout fetch /logout
5. localStorage.setItem('jwt', token) and localStorage.removeItem('jwt') when appropriate

## Etc

1. record not found, record invalid and custom error methods
2. before_action check if authorized where needed
3. skip_before_action :verify_authenticity_token if authenticity error
4. params
5. helper methods: encode, decode, authorize (in application_controller)
6. routes: get '/me', to: "users#show" | post '/signup', to: "users#create" | post '/login', to: "users#login" | post '/logout', to: "users#logout"