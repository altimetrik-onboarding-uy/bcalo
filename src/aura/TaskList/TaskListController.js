({
	doInit : function(component, event, helper) {
		var action = component.get("c.getContactTaskByType");
		action.setParams({
			"contactId": component.get("v.recordId"),
			"type": component.get("v.taskType")
		});
		action.setCallback(this, function(response) {
			if(response.getState() === 'SUCCESS'){
				component.set("v.tasks", response.getReturnValue());
			}
		});
		$A.enqueueAction(action);

		helper.getStatusValues(component);
	},
	handleUpdateTask : function(component, event, helper) {
		helper.updateTask(component,event.getParam("taskItem"));
	}
})