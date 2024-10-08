/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Daniel S
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads () {
     List<Lead> leadsList = [SELECT Id, LastName, Company, Phone, Email FROM Lead WITH USER_MODE];
     
     return leadsList;

    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName () {
    //  The body of the method
    List<Contact> listOfContacts = [SELECT Name, FirstName FROM Contact WHERE FirstName = 'John' WITH USER_MODE];
    
    return listOfContacts;

    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName () {
    //  The body of the method
    List<Contact> listOfContacts = [SELECT Id FROM Contact WHERE LastName IN ('Smith','Jones') WITH USER_MODE];

    List<Id> listOfContactIds = new List<Id>();

    for (Contact c : listOfContacts) {
        listOfContactIds.add(c.Id);
        System.debug(c.Id);
    }
    
    return listOfContactIds;
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunityCountByAccount (Id id) {
    //  The body of the method
    List<Opportunity> listOfWonOpps = [SELECT AccountId, Amount, CloseDate, Name, Stagename FROM Opportunity WHERE StageName = 'Closed Won' AND AccountId = :id WITH USER_MODE];


    return listOfWonOpps;
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount () {
    // The body of the method
    // Solution #1
    // Integer accountTotalCount = [SELECT COUNT() FROM Account WITH USER_MODE];
    // return accountTotalCount;

    //#Solution 2
    AggregateResult[] totalAccCount = [SELECT Count(Id) FROM Account WITH USER_MODE];
    //return Integer.valueOf(totalAccCount[0].get('expr0'));
    return (Integer)totalAccCount[0].get('expr0');
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksDueNextWeek () {
    
    List<Task> taskList = [SELECT Id, Subject FROM Task WHERE ActivityDate = NEXT_N_DAYS:7 WITH USER_MODE];
    
    Map<Id, Task> taskMap = new Map<Id, Task>();

    for (Task t : taskList) {
        taskMap.put(t.Id, t);
    }

    return taskMap;
    
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain () {
    
    String domain = '%example.com';
    
    List<Contact> contactsLists = [SELECT Id,Name, Email FROM Contact WHERE Email LIKE :domain WITH USER_MODE];
    
    return contactsLists;
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        
        String searchKeyword = '%' + keyword + '%';

        List<Opportunity> oppList = [SELECT Id, Name FROM Opportunity WHERE Name LIKE :searchKeyword WITH USER_MODE];
        
        return oppList;
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        List<Case> caseList = [SELECT Id, Origin FROM Case WHERE Origin NOT IN ('Web', 'Email', '', NULL) WITH USER_MODE];

        return caseList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle (String source, String title) {

        //String s = '%' + source + '%';
        String t = '%' + title + '%';    
        
        List<Lead> leadList = [SELECT Id, LeadSource, Title, LastName, Company, Phone, Email FROM Lead WHERE LeadSource = :source OR Title LIKE :t WITH USER_MODE ];

        return leadList;
    }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> listOfLastNames= new List<String>();

        // Query the Contacts
        List<Contact> contacts = [SELECT Id, LastName FROM Contact WHERE AccountId = :accountId WITH USER_MODE];

        // Loop through each Contact and add the LastName to the list
        for (Contact c : contacts) {
            listOfLastNames.add(c.LastName);
        }

        // Return the list of Contact LastNames
        return listOfLastNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Use AggregateQuery to get the total revenue
        AggregateResult[] totalRevenueByStage = [SELECT SUM(Amount) FROM Opportunity WHERE StageName = :stage WITH USER_MODE];

        return (Decimal)totalRevenueByStage[0].get('expr0'); // Replace null with the variable you used to store the result
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {

        List<Account> first10Accounts = [SELECT Id, Name FROM Account WITH USER_MODE ORDER BY Name LIMIT 10]; 

        return first10Accounts; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        List<Opportunity> oppList = [SELECT Id, Amount, CloseDate FROM Opportunity WHERE Amount > 100000 WITH USER_MODE ORDER BY CloseDate LIMIT 5];
        return oppList; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        List<Contact> birthDateList = [SELECT Id, Birthdate FROM Contact WITH USER_MODE ORDER BY Birthdate DESC LIMIT 3];
        return birthDateList; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 16
     * Retrieves the first 5 Accounts with the most recent Birthdate.

        return birthDateList; // Replace null with the variable you used to store the result
    }
    */
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus(String status) {

        List<Case> caseList = [SELECT Id, CreatedDate FROM Case WHERE Status = :status WITH USER_MODE LIMIT 10 OFFSET 5];
        return caseList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {

        Set<Id> caseIdSet = new Set<Id>();

        List<Case> caseList = [SELECT Id FROM Case WHERE AccountId = :accountId WITH USER_MODE];

        for (Case c : caseList) {
            caseIdSet.add(c.Id);
        }

        return caseIdSet; // Replace null with the variable you used to store the result
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        //List<Account> accList = [SELECT Id, Name FROM Account WHERE BillingCountry NOT IN (:country) WITH USER_MODE];
        List<Account> accList = [SELECT Id, Name FROM Account WHERE BillingCountry != :country WITH USER_MODE];

        for (Account a : accList) {
            accountIdsToNames.put(a.Id, a.Name);
        }
            
        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {

        String accName = [SELECT Account.Name, (SELECT Id FROM Contacts WHERE Id = :contactId) FROM Account WITH USER_MODE].Name;

        return accName; // Replace null with the variable you used to store the result
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        
        Account acc = [SELECT Id, Name, (SELECT Id, Name FROM Opportunities WHERE AccountId = :accountId) FROM Account WITH USER_MODE];
        System.debug(acc);
        return acc; // Replace null with the variable you used to store the result
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        //Contact Mailing Address the same as Account Billing Address
        // Query the Account
        String accBillingState = [SELECT Id, (SELECT Id FROM Contacts WHERE AccountId = :accountId) FROM Account WITH USER_MODE].BillingState;
        
        // Query the Contacts
        List<Contact> conList = [SELECT Id FROM Contact WHERE MailingState = :accBillingState WITH USER_MODE];

        return null; // Replace null with the variable you used to store the result
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads
        List<Lead> leadList = [SELECT Id, Email FROM Lead WHERE Id IN :leadIds WITH USER_MODE];

        // Create a set of email domains from the Leads
        Set<String> leadEmailDomains = new Set<String>();

        // Loop through each Lead
            // Get the email from the Lead
            // Check if the email is not null
            // Add the email domain to the set
        for (Lead lead : leadList) {
            if (lead.email != null) {
                //leadEmailDomains.add(lead.Email.substring(0, lead.Email.lastIndexOf('@')));
                String domain = lead.Email.substring(lead.Email.indexOf('@') + 1).toLowerCase();
                leadEmailDomains.add(domain);
            }
        }        
    
        List<String> domainConditions = new List<String>();

        for (String domain : leadEmailDomains) {
            domainConditions.add('Website LIKE \'%' + domain + '%\'');
        }
    
        String query = 'SELECT Id, Website FROM Account WHERE ' + String.join(domainConditions, ' OR ') + ' WITH USER_MODE';
        List<Account> accList = Database.query(query, AccessLevel.USER_MODE); //This requires additional method to escape the quotes and prevent SOQL injection!?

        return accList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items
        List<OpportunityLineItem> origOppLineItems = [SELECT Id, Quantity, PricebookEntryId, Product2Id, TotalPrice, UnitPrice From OpportunityLineItem WHERE OpportunityId = :origOppId WITH USER_MODE];

        // Create a list to hold the new line items
        List<OpportunityLineItem> newOppLineItems = new List<OpportunityLineItem>();

        // Generate a random number between 1 and 3
        Integer randomNumber = Integer.valueOf(Math.random() * 3) + 1;

        // Loop through each cloned Opportunity Id
            // Loop through each original line item
                // Clone the original line item and add the random number to the quantity
        for (Id cloneOppId : cloneOppIds) {
            for (OpportunityLineItem o : origOppLineItems) {
                newOppLineItems.add(new OpportunityLineItem(
                    OpportunityId = cloneOppId,
                    Quantity = o.Quantity + randomNumber,
                    //TotalPrice = o.TotalPrice,
                    UnitPrice = o.UnitPrice,
                    Product2Id = o.Product2Id,
                    PricebookEntryId = o.PricebookEntryId
                ));
            }
        }


        // Insert the new line items
        insert as User newOppLineItems;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {        
        return null; // Replace null with the variable you used to store the result
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities

        // Create a set of Account Ids from the Opportunities

        // Query the Contacts

        // Loop through each Contact and add the Account Id and Contact to the map
        
        // Loop through each Opportunity

                // Update the Opportunity primary contact from accountToContactMap

        // Update the Opportunities
    }
}