trigger TaskRecordTypeForSendEmail on Task  (after delete, after insert, after update, before delete, before insert, before update)
{
    if(Trigger.isBefore && Trigger.isInsert)
    {
    
        Map<String, Schema.RecordTypeInfo > taskRecordTypes = Task.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id recordTypeId = taskRecordTypes.get('Auto Gen Mail').getRecordTypeId();
        
        for ( Task tsk : Trigger.new)
        {
            if(tsk.Subject.contains('Email'))
                tsk.RecordTypeId = recordTypeId;
        }
    }
}