###
	Doc

	@module      :: Model
	@description :: A short summary of how this model works and what it represents.
	@docs		:: http://sailsjs.org/#!documentation/models
###

module.exports =

	attributes:

		name:
			type: 'string'
			required: true

		path:
			type: 'string'
			required: true

		fullName:
			type: 'string'

		children:
			type: 'array'
			default: []

		read:
			type: 'array'
			default: [/*/]

		write:
			type: 'array'
			required: true

	beforeCreate: (value,next) ->
		value.fullName = value.path + '/' + value.name
		#update parent if it exists
		#recursively create all the children using a continuation
		next()