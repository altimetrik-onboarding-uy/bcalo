({
	updateTask : function(component, aTask) {
		var action = component.get("c.updateTask");
		action.setParams({
			"task": aTask
		});
		console.log(aTask.Status__c)
		action.setCallback(this, function(response){
			if(response.getState() === 'SUCCESS') {
				if(aTask.Status__c === "Completed") {
					var taskList = component.get("v.tasks");
					var index = taskList.findIndex(function(task){return task.Id === aTask.Id;});
					if(index > -1) {
						taskList.splice(index,1);
					}
					component.set("v.tasks", taskList);
				}
				//this.displayMessage("Success!","Your task was updated.","success");
			} else {
				//this.displayMessage("error","Something has gone wrong!","Unfortunately", "there was a problem updating the record.");
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

	}, getStatusValues : function(component) {
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
				component.set("v.statusValues", options);
			}
		});
		$A.enqueueAction(action);

	}, getTasks : function(component) {
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
	}
})