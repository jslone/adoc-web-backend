###
	canWrite
  
	@module      :: Policy
	@description :: Check to see if the current user has write permissions
					on current doc and parent doc
###

module.exports = (req,res,next) ->
	if req.target.controller == 'doc'
		Doc.findOne(fullName: req.body.path + '/' + req.body.name).done (err,doc) ->
			if not doc?
				Doc.findOne({fullName: req.body.path}).done (err,doc) ->
					if not doc? or doc.canWrite req.user?.email
						next()
					else
						res.forbidden 'You do not have write permissions for this doc'
			else if doc.canWrite req.user?.email
				next()
			else
				res.forbidden 'You do not have write permissions for this doc'
	else
		next()