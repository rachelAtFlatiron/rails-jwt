import './App.css';
import React, { useState, useEffect } from 'react';

function App() {
  const loginBody = {
    username: '',
    password: ''
  }
  const signupBody = {
    username: '',
    password: '',
    email: ''
  }
  //STATES
  let [loginData, setLoginData] = useState({...loginBody})
  let [signupData, setSignupData] = useState({...signupBody})
  let [user, setUser] = useState({ username: '' })

 /*****TODO: auto login******/
  useEffect(() => {
    let token = localStorage.getItem('token')
    if(token && !user.username){
      fetch('http://localhost:3000/me', {
        method: 'POST',
        body: JSON.stringify({token: token}),
        headers: {
          'content-type': 'application/json'
        }
      })
      .then(res => res.json())
      .then(data => {
        console.log(data)
      })
    }
  }, [])
 /*****TODO: logout user******/
  const logout = () => {

  }
  /*************FORM CHANGE AND SUBMIT************/

  //user enters login info
  function loginChange(e) {
    setLoginData({
      ...loginData,
      [e.target.name]: e.target.value
    })
  }

  /*****TODO: login******/
  const loginSubmit = (e) => {
    e.preventDefault()
  }

  //user enters sign up info
  const signUpChange = (e) => {
    setSignupData({
      ...signupData,
      [e.target.name]: e.target.value
    })
  }

  /*****TODO: sign up new user******/
  const signUpSubmit = (e) => {
    e.preventDefault()
    fetch('http://localhost:3000/signup', {
      method: 'POST',
      body: JSON.stringify(signupData),
      headers: {
        'Content-Type': 'application/json'
      }
    })
    .then(res => res.json())
    .then(data => {
      setUser(data.user)
      localStorage.setItem('token', data.token)
    })
    .catch(err => console.log(err))
  }

  //RENDER 
  return (
    <div className="App">
      { user.username.length === 0 ? 
        <div>
          <h1>Login</h1>
          <form onChange={e => loginChange(e)} onSubmit={e => loginSubmit(e)}>
            <input type="text" name="username" placeholder="username" value={loginData.username}  />
            <input type="text" name="password" placeholder="password" value={loginData.password} />
            <input type="submit" name="submit"/>
          </form>

          <h1>Signup</h1>
          <form onChange={e => signUpChange(e)} onSubmit={e => signUpSubmit(e)}>
            <input type="text" name="username" placeholder="username" value={signupData.username} />
            <input type="text" name="email" placeholder="email" value={signupData.email}/>
            <input type="text" name="password" placeholder="password" value={signupData.password} />
            <input type="submit" name="submit" />
          </form>
        </div>
        :
        <div>
          <h1>Hi {user.username}</h1>
          <button onClick={logout}>Logout</button>
        </div>
    }
    </div>
  );
}

export default App;
