trigger Friend_Trigger on LJ_Friend__c (before insert, before update) {
    if (Trigger.isBefore) {

        Set<String> Exceptions = new Set<String>();
        for (String s : 'aviacomment,davidov,denokan,flying_elk,juicy_fruit,ploughlike_elk,rabies_rabbit'.split(',')) Exceptions.add(s);
        
        Set<String> FriendOfMySet = new Set<String>();
        Set<String> AllSet = new Set<String>();        
        
        for (LJ_Friend__c line : Trigger.New) {
            String Pidorasy = '';
            String LeadsForAdd = '';            
            Integer mq = 0;
            Integer nmq = 0;
            Set<String> FriendOfMy = new Set<String>();
            Set<String> Friends = new Set<String>();            
            for (String s : line.Mutal__c.split(', ')) {
                FriendOfMy.add(s);
                AllSet.add(s);
                mq++;
                
            }

            //Set<String> Friends = new Set<String>();
            for (String s : line.Friends__c.split(', ')) {
                Friends.add(s);
                AllSet.add(s);
                
                if (!FriendOfMy.contains(s)) {
                    if (!Exceptions.contains(s)) Pidorasy += s + '\n';
                    nmq++;
                }
            }
            
            List<LJ_User__c> LJU_Update = new List<LJ_User__c>();
            Set<String> Processed = new Set<String>();
            for (LJ_User__c lju : [SELECT Id, My_Friend__c, Friend_of_Myne__c, Nickname__c, Name, Social_Score__c FROM LJ_User__c WHERE Nickname__c IN : AllSet]) {
                if (Friends.contains(lju.Nickname__c)) lju.My_Friend__c = true;
                if (FriendOfMy.contains(lju.Nickname__c)) lju.Friend_of_Myne__c = true;
                LJU_Update.add(lju);
                Processed.add(lju.Nickname__c);
            }
            update LJU_Update;

            List<LJ_User__c> LJU_Insert = new List<LJ_User__c>();
            for (String ast : AllSet) {
                if (Processed.contains(ast) == false) {
                    LJ_User__c lju = new LJ_User__c(
                        Nickname__c = ast,
                        Social_Score__c = 0
                    );                
                    if (Friends.contains(lju.Nickname__c)) lju.My_Friend__c = true;
                    if (FriendOfMy.contains(lju.Nickname__c)) lju.Friend_of_Myne__c = true;
                    LJU_Insert.add(lju);
                }
            }
            insert LJU_Insert;          

            for (String s : FriendOfMy) {
                if (!Friends.contains(s)) {
                    LeadsForAdd  += s + '\n';
                }
            }


            line.Not_Mutal__c = Pidorasy;
            line.Not_Friend__c = LeadsForAdd;
            line.Mutal_Quantity__c = mq;
            line.Not_Mutal_Quantity__c = nmq;
        }
    }
}