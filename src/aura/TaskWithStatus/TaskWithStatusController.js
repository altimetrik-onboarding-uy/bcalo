({
	doInit : function(component, event, helper) {
		var options = [
			{ value: "New", label: "New" },
			{ value: "In Progress", label: "In Progress" },
			{ value: "Completed", label: "Completed" }
		];
		component.set("v.options", options);
	},
	handleStatusChange : function(component, event, helper) {
		console.log(component.get("v.task.Status__c"));
	},
	updateTask : function(component, event, helper) {
		var task = component.get("v.task");
		var updateTaskEvent = component.getEvent("updateTask");
		updateTaskEvent.setParams({
			"taskItem": task
		});
		updateTaskEvent.fire();
	}
})