passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
bcrypt = require 'bcrypt'

findById = (id,callback) ->
	User.findOne(id).done (err,user) ->
		if err
			callback null,null
		else
			callback null,user

findByEmail = (username,callback) ->
	User.findOne(email: username).done (err,user) ->
		if err
			callback null,null
		else
			callback null,user

passport.serializeUser (user,done) ->
	done null,user.id

passport.deserializeUser (id,done) ->
	findById id,done

passport.use new LocalStrategy (username, password, done) ->
	findByEmail username, (err,user) ->
		if err
			done null,err
		# these messages probably shouldn't be different in prod
		else if not user?
			done null,false, message: 'Unknown user ' + username
		else
			bcrypt.compare password,user.password, (err,res) ->
				if !res
					done null,false,message: 'Invalid password'
				else
					done null,user,message: 'Login successful'