({
	doInit : function(component, event, helper) {
		helper.getTasks(component);
		helper.getStatusValues(component);
	},
	handleUpdateTask : function(component, event, helper) {
		helper.updateTask(component,event.getParam("taskItem"));
	}
})