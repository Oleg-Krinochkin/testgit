trigger Contact on Contact (after insert) {
   
   // byzaak
// herrokuuuu 
// jjj
    
    Set<Id> Contacts = new Set<Id>();
    for (Contact c : Trigger.New) Contacts.add(c.Id);

    Map<Id, Contact> ContactMap = new Map<Id, Contact>([SELECT Id, Name, Level__c, AccountId, Account.OwnerId, OwnerId FROM Contact WHERE Id IN :Contacts]);
    
    List<Case> CaseList  = new List<Case>();    
    for (Contact c : Trigger.New) {
        Case cs = new Case(ContactId = c.Id, Status = 'Working', Origin = 'New Contact');
        Id AccountId = ContactMap.get(c.Id).Account.OwnerId;
            
        if (c.Level__c != NULL) {
             if (c.Level__c.equals('Primary')) cs.Priority = 'High';
             else if (c.Level__c.equals('Secondary')) cs.Priority = 'Medium';
             else if (c.Level__c.equals('Tertiary')) cs.Priority = 'Low';
        } 
        if (AccountId != NULL) {
            cs.OwnerId = AccountId;
            cs.AccountId = c.AccountId;
        }
        CaseList.add(cs);
    }
    insert CaseList;
    
    Set<Id> CsLst = new Set<Id>(); 
    for (Case c : CaseList) CsLst.add(c.Id);
    
    List<Task> Tasks = new List<Task>();  
    for (Case c : [SELECT Id, CaseNumber, ContactId FROM Case WHERE Id IN :CsLst]) {
        Contact ct = ContactMap.get(c.ContactId);
        Date DueDate = NULL;
        if (ct.Level__c != NULL) {
            if (ct.Level__c.equals('Primary')) DueDate = system.today().addDays(7); 
            else if (ct.Level__c.equals('Secondary')) DueDate = system.today().addDays(14); 
            else if (ct.Level__c.equals('Tertiary')) DueDate = system.today().addDays(21); 
        } 
                
        Task t = new Task(  Subject = Label.Task_Subject.replace('{contact name}', ct.Name).replace('{case number}', c.CaseNumber),
                            ActivityDate = DueDate, OwnerId = ct.OwnerId, WhatId = c.Id );
        Tasks.add(t);
    }
    insert Tasks;

}