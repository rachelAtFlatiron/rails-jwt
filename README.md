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

has_secure_password: in model, creates password_digest from password param

CSRF: made for classical web apps, makes sure requests coming from same server...use
protect_from_forgery with: :null_session
to override

JWT: use token = encode_token({user_id: @user.id}) and JWT.decode(token, 'secret', true, algorithm: 'HS256')

request.headers