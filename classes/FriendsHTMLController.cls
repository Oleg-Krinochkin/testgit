public with sharing class FriendsHTMLController {

	public String getHTML_Line() {
		String PId = ApexPages.currentPage().getParameters().get('id');
		String HTML = '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">\n<head profile="http://selenium-ide.openqa.org/profiles/test-case">\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />\n<link rel="selenium.base" href="http://www.livejournal.com/" />\n<title>New Test</title>\n</head>\n<body>\n<table cellpadding="1" cellspacing="1" border="1">\n<thead>\n<tr><td rowspan="1" colspan="3">New Test</td></tr>\n</thead><tbody>\n';
		for (Fiend_Plan__c pl : [SELECT Id, Prospect_List__c FROM Fiend_Plan__c WHERE Id = :PId]) {
			for (String str : pl.Prospect_List__c.split('\n')) {
				if (str.contains(' ') == false) {
					HTML += '<tr>\n	<td>open</td>\n	<td>http://' + str + '.livejournal.com</td>\n	<td></td>\n</tr>\n<tr>\n	<td>open</td>\n	<td>http://www.livejournal.com/friends/add.bml?user=' + str + '</td>\n	<td></td>\n</tr>\n<tr>\n	<td>click</td>\n	<td>id=fg:bit_6</td>\n	<td></td>\n</tr>\n<tr>\n	<td>clickAndWait</td>\n	<td>css=p &gt; input[type=&quot;submit&quot;]</td>\n	<td></td>\n</tr>\n';
				}
			}
		}
		HTML += '</tbody></table>\n</body>\n</html>';
		return HTML;
	}

	public String getHTML_RemFR() {
		String PId = ApexPages.currentPage().getParameters().get('id');
		String HTML = '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">\n<head profile="http://selenium-ide.openqa.org/profiles/test-case">\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />\n<link rel="selenium.base" href="http://www.livejournal.com/" />\n<title>New Test</title>\n</head>\n<body>\n<table cellpadding="1" cellspacing="1" border="1">\n<thead>\n<tr><td rowspan="1" colspan="3">New Test</td></tr>\n</thead><tbody>\n';
		for (LJ_Friend__c pl : [SELECT Id, Not_Mutal__c FROM LJ_Friend__c WHERE Id = :PId]) {
			for (String str : pl.Not_Mutal__c.split('\n')) {
				if (str.contains(' ') == false) {
					HTML += '<tr>\n	<td>open</td>\n	<td>http://livejournal.com/friends/add.bml?user=' + str + '</td>\n	<td></td>\n</tr>\n<tr>\n	<td>clickAndWait</td>\n	<td>name=action:delete</td>\n	<td></td>\n</tr>\n';
				}
			}
		}
		HTML += '</tbody></table>\n</body>\n</html>';
		return HTML;
	}

	
	

}