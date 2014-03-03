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

		read:
			type: 'array'
			default: [/.*/]

		write:
			type: 'array'
			required: true

	beforeCreate: (value,next) ->
		value.fullName = value.path + '/' + value.name
		value.children = []
		#recursively create all the children using a continuation
		createChildren = (childrenLeft) ->
			if childrenLeft.length == 0
				next()
			else
				childName = childrenLeft.pop()
				child = value[childName]
				child.name = childName
				child.path = value.fullName
				child.write = value.write
				delete value[childName]
				Doc.create(child).done (err,doc) ->
					if err
						console.log err
					value.children.push doc.id
					createChildren childrenLeft

		childrenNames = (childName for childName of value when typeof value[childName] == 'object' and not Doc.attributes[childName])
		createChildren childrenNames

	afterCreate: (doc,next) ->
		#update the parent if it exists
		Doc.findOne(fullName : doc.path).done (err,parentDoc) ->
			parentDoc?.children.push doc.id
			parentDoc?.save (err) ->
				console.log 'Error updating parentDoc:', err
			next()