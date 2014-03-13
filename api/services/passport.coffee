passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
bcrypt = require 'bcrypt'

findById = (id,callback) ->
	User.findOne(id).done (err,user) ->
		if err
			callback null,null
		else
			callback null,user

findByEmail = (email,callback) ->
	User.findOne(email: email).done (err,user) ->
		if err
			callback null,null
		else
			callback null,user

passport.serializeUser (user,done) ->
	done null,user.id

passport.deserializeUser (id,done) ->
	findById id,done

passport.use new LocalStrategy usernameField: 'email', (email, password, done) ->
	findByEmail email, (err,user) ->
		if err
			done true,err
		# these messages probably shouldn't be different in prod
		else if not user?
			done true,false, message: 'Unknown user ' + email
		else
			bcrypt.compare password,user.password, (err,res) ->
				if !res
					done true,false,message: 'Invalid password'
				else
					done null,user,message: 'Login successful'
