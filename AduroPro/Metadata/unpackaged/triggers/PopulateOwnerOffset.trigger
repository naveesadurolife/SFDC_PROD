trigger PopulateOwnerOffset on Event (before insert,before update) {
    if((TRIGGER.isInsert || TRIGGER.isUpdate) && TRIGGER.isBefore) {
        PopulateOwnerOffsetHandler.populateOffset(TRIGGER.newMap,TRIGGER.oldMap,TRIGGER.New);
    }
}