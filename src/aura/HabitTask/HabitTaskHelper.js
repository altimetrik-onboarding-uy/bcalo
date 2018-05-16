({
	updateHabitTask : function(component, habit, achieved) {
		var action = component.get("c.updateHabitTask");
		action.setParams({
			"habit": habit,
			"achieved": achieved
		});
		action.setCallback(this, function(response){
			if(response.getState() === 'SUCCESS') {
				component.set("v.task", response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	}
})