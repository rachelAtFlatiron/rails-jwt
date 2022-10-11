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

  //USEEFFECT FOR AUTO LOGIN
  useEffect(() => {
    let token = localStorage.getItem('jwt')
    if(token && !user.name){
      fetch('http://localhost:3000/me', {
        headers: {
          "Authorization": `Bearer ${token}`
        }
      })
      .then(res => res.json())
      .then(data => {
        setUser(data)
      })
    }
  }, [])

  //logout
  function logout() {
    //reset current_user on backend
    fetch('http://localhost:3000/logout', {
      method: 'POST'
    })
    .catch(err => console.log(err))
    //remove login info from session
    localStorage.removeItem("jwt")
    setUser({ username: '' })
  }

  /*************FORM CHANGE AND SUBMIT************/

  //user enters login info
  function loginChange(e) {
    setLoginData({
      ...loginData,
      [e.target.name]: e.target.value
    })
  }

  //user submits login info
  const loginSubmit = (e) => {
    console.log(loginData)
    e.preventDefault()
    fetch('http://localhost:3000/login', {
      method: 'POST',
      body: JSON.stringify(loginData),
      headers: {
        'content-type': 'application/json'
      }
    })
    .then(res => res.json())
    .then(data => {
      //SET JWT AND USER ON SUCCESSFUL LOGIN
      console.log(data)
      if(data.token){
        localStorage.setItem("jwt", data.token)
        setUser(data.user)
        setLoginData(loginBody)
      }
    })
  }

  //user enters sign up info
  const signUpChange = (e) => {
    setSignupData({
      ...signupData,
      [e.target.name]: e.target.value
    })
  }

  //user submits signup info
  const signUpSubmit = (e) => {
    e.preventDefault()
    fetch('http://localhost:3000/signup', {
      method: 'POST',
      body: JSON.stringify(signupData),
      headers: {
        'content-type': 'application/json'
      }
    })
    .then(res => res.json())
    .then(data => {
      //SET JWT AND USER ON SUCCESSFUL LOGIN
      localStorage.setItem("jwt", data.token)
      setUser(data.user)
      setSignupData({...signupBody})
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
