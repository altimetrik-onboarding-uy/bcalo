({
	updateTask : function(component, event, helper) {
		var task = component.get("v.task");
		var updateTaskEvent = component.getEvent("updateTask");
		updateTaskEvent.setParams({
			"taskItem": task
		});
		updateTaskEvent.fire();
	}
})