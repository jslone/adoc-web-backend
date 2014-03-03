###
	DocController

	@module      :: Controller
	@description	:: A set of functions called `actions`.

	             Actions contain code telling Sails how to respond to a certain type of request.
	             (i.e. do stuff, then send some JSON, show an HTML page, or redirect to another URL)

	             You can configure the blueprint URLs which trigger these actions (`config/controllers.js`)
	             and/or override them with custom routes (`config/routes.js`)

	             NOTE: The code you write here supports both HTTP and Socket.io automatically.

	@docs        :: http://sailsjs.org/#!documentation/controllers
###

module.exports =

	#allows for lookup with a vanity url
	lookup: (req,res) ->
		url = req.params[0] # wildcard portion of route
		Doc.findOne(fullName : url).done (err,doc) ->
			if err
				res.json err: err
			else
				res.json(doc)
	
	# need to use this to default write to [currentUser], and authenticate updating the parent
	#create: (req,res) -> 
	
	###
		Overrides for the settings in `config/controllers.js`
		(specific to DocController)
	###
	_config: {}