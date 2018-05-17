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
				if(achieved) {
					this.displayMessage("Congrats!","You have earned " + habit.Points_Award__c + " points." ,"success");
				} else {
					this.displayMessage("Whops!","You have lost " + habit.Points_Award__c + " points.","error");
				}
			}
		});
		$A.enqueueAction(action);
	},

	displayMessage : function(aTitle, aMessage, aType) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: aTitle,
			message: aMessage,
			type: aType
		});
		toastEvent.fire();

	}
})