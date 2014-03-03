###
  User
  
  @module      	:: Model
  @description 	:: A short summary of how this model works and what it represents.
  @docs			:: http://sailsjs.org/#!documentation/models
###
bcrypt = require "bcrypt"

module.exports =

	attributes:

		name:
			type: 'string'
			required: true
			minLength: 3
			maxLength: 20
			unique: true

		email:
			type: 'email'
			required: true
			unique: true

		password:
			type: 'string'
			required: true
			minLength: 8

		toJSON: () ->
			obj = @toObject()
			delete obj.password
			obj

	beforeCreate: (values,next) ->
		bcrypt.hash values.password, 10, (err,hash) ->
			if err
				next err
			else
				values.password = hash
				next()