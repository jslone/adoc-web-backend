###
	canRead
  
	@module      :: Policy
	@description :: Check to see if the current user has read permissions
					Only applies to Docs
###
module.exports = (req,res,next) ->
	if req.target.controller == 'doc'
		key = null
		if req.target.action == 'find'
			if req.param('id')?
				key = req.param('id')
		if req.target.action == 'lookup'
			key = fullName: req.param[0]
		if key isnt null
			Doc.findOne(key).done (err,doc) ->
				matched = false
				if "all" in doc.read
					matched = true
					next()
				for matcher in doc.read
					if typeof matcher == 'string' and req.user?.username == matcher
						matched = true
						next()
					if matcher instanceof RegExp and matcher.test req.user?.username
						matched = true
						next()
				if not matched
					res.forbidden 'You do not have permisson to read this doc.'
		else
			next()
	else
		next()