###
	Doc

	@module      :: Model
	@description :: A short summary of how this model works and what it represents.
	@docs		:: http://sailsjs.org/#!documentation/models
###

isAllowed = (username,permissions) ->
	if 'all' in permissions
		true
	else
		for pattern in permissions
			regMatch = pattern.match /\/(.*)?\/([i|g|m]+)?/
			if not regMatch?
				if pattern == username
					return true
			else
				regexp = if regMatch[2]? then new RegExp regMatch[1],regMatch[2] else new RegExp regMatch[1]
				console.log username
				console.log regMatch
				console.log regexp.test username
				if regexp.test username
					return true
		false

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
			unique: true

		children:
			type: 'array'

		read:
			type: 'array'
			defaultsTo: ['all']

		write:
			type: 'array'
			required: true

		canRead: (username) ->
			isAllowed username,@read

		canWrite: (username) ->
			isAllowed username,@write

	beforeCreate: (value,next) ->
		value.fullName = if value.path == '/' then value.name else value.path + '/' + value.name
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
					if err or not doc?
						console.log err
						delete value.children
						next()
					else
						child = id: doc.id, name: doc.name, isLeaf: doc.children.length == 0
						value.children.push child
						createChildren childrenLeft

		childrenNames = (childName for childName of value when typeof value[childName] == 'object' and not Doc.attributes[childName])
		createChildren childrenNames

	afterCreate: (doc,next) ->
		#update the parent if it exists
		Doc.findOne(fullName : doc.path).done (err,parentDoc) ->
			child = id: doc.id, name: doc.name, isLeaf: doc.children.length == 0
			parentDoc?.children.push child
			parentDoc?.save (err) ->
				console.log 'Error updating parentDoc:', err
			next()
