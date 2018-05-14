({
	updateTask : function(component, aTask) {
		var action = component.get("c.updateTask");
		action.setParams({
			"task": aTask
		});
		action.setCallback(this, function(response){
			if(response.getState() === "SUCCESS") {
				if(aTask.Status__c === "Completed") {
					var taskList = component.get("v.tasks");
					var index = taskList.findIndex(function(task){return task.Id === aTask.Id;});
					if(index > -1) {
						taskList.splice(index,1);
					}
					component.set("v.tasks", taskList);
					this.displayMessage("Success!","Your task was updated.","success");
				}
			} else {
				this.displayMessage("error","Something has gone wrong!","Unfortunately", "there was a problem updating the record.");
			}
		});
		$A.enqueueAction(action);

	}, displayMessage : function(aTitle, aMessage, aType) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: aTitle,
			message: aMessage,
			type: aType
		});
		toastEvent.fire();
	}
})