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

		attr:
			type: 'array'
			default: []

		children:
			type: 'array'
			default: []