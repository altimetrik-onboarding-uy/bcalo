({
	clickAddButton : function(component, event, helper) {
		var taskUpdated = component.get("v.task");
		helper.updateHabitTask(component, taskUpdated, true);
	},
	
	clickSubtractButton : function(component, event, helper) {
		var taskUpdated = component.get("v.task");
		helper.updateHabitTask(component, taskUpdated, false);
	}
})