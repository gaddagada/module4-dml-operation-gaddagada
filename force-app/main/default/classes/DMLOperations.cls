/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Gayathri Addagada 
 */


public with sharing class DMLOperations {
/**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account newAccount = new Account();

        // Ensure the required fields are set for the Account object
        newAccount.Name = 'Test Account 01 ' + Datetime.now().getTime(); // Unique name based on current timestamp
        newAccount.AccountNumber = '1234'; 

        // Insert the Account into the database
        insert newAccount;

        return newAccount.Id;
    
    }


    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account account = new Account(Name = 'Test Account', Industry = 'Technology');

        // Insert the Account
        insert account; 

    }
    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact contact = new Contact(); 

        // Set some fields on the Contact
        contact.FirstName = 'Harry';
        contact.LastName = 'Potter'; 
        contact.Email = 'harry@hogwarts.com';

        // Set the AccountId field to the given accountId
        contact.AccountId = accountId;

        // Insert the Contact into the database
        insert contact; 

        // // Return the Id of the newly created Contact
        // System.debug('Question 1 : ' + 'Account Id: '+ newAccount.Id + 'Account FirstName: ' + newAccount.FirstName + 'Account LastName: ' + newAccount.LastName+ 'Account Email: ' + newAccount.Email);

        return contact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        Contact contact  = [SELECT id FROM Contact WHERE Id = :contactId];

        // Update the Contact's last name
        contact.LastName = newLastName;

        // Update the Contact in the database
        update contact;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        Opportunity opportunity = [SELECT id FROM Opportunity WHERE Id = :oppId];

        // Update the Opportunity's stage
        opportunity.stageName = newStage;

        // Update the Opportunity in the database
        update opportunity;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];

        // Update the Account with the given Id with the new name and industry
        account.Name = newName;
        account.Industry = newIndustry;

        update account;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
            // Set the Opportunity's Stage to Qualification
            // Set the Opportunity's Close Date to 3 months from today
            // Set the Opportunity's Amount to 50000
        // Upsert the opportunities List so that records are either updated or created

        for(Opportunity opp : opportunities) {
            opp.StageName = 'Qualification';
            opp.CloseDate = Date.today().addMonths(3);
            opp.Amount = 50000;
        }

        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * HINT: There should not be duplicate opportunites based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        
            // Query to check if account already exists
            List<Account> accountList  = [SELECT Id  FROM Account WHERE Name = :accountName];
            Account newAccount; 

            // If not exist then create account with account name, ceate the new account
            if(accountList.isEmpty()){
                newAccount = new Account(Name = accountName);
                upsert newAccount; // Upsert to insert the account if it doesn't exist
            } else {
                newAccount = accountList[0]; // Assign the queried account
            }

            // Query to get exisiting opportunities 
            List<Opportunity> existingOpportunities = [SELECT Id, Name FROM Opportunity WHERE Name IN : oppNames];
            // Create a list of Opportunities
            List<Opportunity> oppsToProcess = new List<Opportunity>();  

            // Loop through each Opportunity name
            for (String oppName : oppNames) {
                // Create an Opportunity with the given name
                Opportunity newOpp = new Opportunity(Name = oppName, AccountId = newAccount.Id, StageName = 'Prospecting', CloseDate = Date.today());
        
                for (Opportunity existingOpp : existingOpportunities) {
                    if (existingOpp.Name == oppName) {
                        newOpp.Id = existingOpp.Id;
                        break;
                    }
                }

                // Add the Opportunity to the list
                oppsToProcess.add(newOpp);
            }
        
            // Upsert the list of opportunities (insert new or update existing)
            upsert oppsToProcess;
        }


    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];
        Account account  = new Account(); 


		// if the Account exists, update the description
		// otherwise, create a new Account and set the description
        if(!accounts.isEmpty()){
            account = accounts[0];
            account.description = 'Updated Account';
        }else{
            account.Name = accountName;
            account.Description = 'New Account';
        }

		// Upsert the Account
        upsert account; 

        // Return the upserted Account
        return account;  
    }

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact

		// Extract the Account Name from Contact's LastName

		// Get the account based on the name or create one if it doesn't exist

		// Link the Contact to its Account using the Account Id

		// Upsert the Contacts

        for(Contact contact : contactsToUpsert) {
            contact.accountid = upsertAccount(contact.LastName).Id;
        }
        upsert contactsToUpsert;
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {

        List<Lead> leads= new List<Lead>();

        // Loop through each Lead name
        for(String leadName : leadNames){
            leads.add(new Lead(LastName = leadName, Company = leadName));
        }
        // Insert the Leads
        insert leads; 

        // Delete the Leads
        delete leads;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        List<Case> caseList = new List<Case>(); 

        for(Integer i = 0; i < numOfCases; i++){
            caseList.add(new Case(Origin = 'Phone'));
        }

        // Insert the cases
        insert caseList;

        // Delete the cases
        delete caseList;
    }
}

