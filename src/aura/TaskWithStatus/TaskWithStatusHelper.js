({
	getStatusValues : function(component) {
		var action = component.get("c.getStatusFieldValues");
		action.setCallback(this, function(response){
			if(response.getState() === 'SUCCESS') {
				var options = [];
				var statusValues = response.getReturnValue();
				for (var i = 0; i < statusValues.length; i++) {
					options.push({
						label: statusValues[i],
						value: statusValues[i]
					});
				}
				component.set("v.options", options);
			}
		});
		$A.enqueueAction(action);
	}
})