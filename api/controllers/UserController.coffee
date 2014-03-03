###
  UserController
 
  @module       :: Controller
  @description  :: A set of functions called `actions`.
 
                  Actions contain code telling Sails how to respond to a certain type of requeerr: st.
                  (i.e. do stuff, then send some JSON, show an HTML page, or redirect to another URL)
 
                  You can configure the blueprint URLs which trigger these actions (`config/controllers.js`)
                  and/or override them with custom routes (`config/routes.js`)
 
                  NOTE: The code you write here supports both HTTP and Socket.io automatically.
 
  @docs         :: http://sailsjs.org/#!documentation/controllers
###
passport = require "passport"

module.exports =

  auth: (req,res) ->
    (passport.authenticate 'local', (err,user,info) ->
      if err or !user
        res.json success: false, err: err
      else
        req.logIn user, (err) ->
          res.json success: !err, err: err)(req,res)
  deauth: (req,res) ->
    req.logout
  
  _config: {}