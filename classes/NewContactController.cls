public with sharing class NewContactController {

	ApexPages.StandardSetController setCon;
	public Contact ct { get; set; }

	public NewContactController(ApexPages.StandardSetController sc) {
		this.setCon = sc;
		ct = (Contact)setCon.getRecord();
	}

}