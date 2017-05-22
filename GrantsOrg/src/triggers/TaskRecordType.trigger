trigger TaskRecordType on Task  (after delete, after insert, after update, before delete, before insert, before update)
{
    if(Trigger.isBefore && Trigger.isInsert)
    {
    
        Map<String, Schema.RecordTypeInfo > taskRecordTypes = Task.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id recordTypeId = taskRecordTypes.get('Contact Person').getRecordTypeId();
        
        for ( Task tsk : Trigger.new)
        {
            if(tsk.Subject.equals('Contact Person Verification'))
                tsk.RecordTypeId = recordTypeId;
        }
    }
}