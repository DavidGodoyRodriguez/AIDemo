public with sharing class CallClassificationService {

    public static CallClassificationDTO classifyCall(List<String> transcribedAudioList){
        String transcribedAudio = String.join(transcribedAudioList, '');

        LLMDTO.RequestCompletion requestCompletion = new LLMDTO.RequestCompletion();
        requestCompletion.model = getModelId();
        requestCompletion.prompt = String.format(getPrompt(), new List<String>{transcribedAudio});
        requestCompletion.temperature = 0;

        String message = LLMFacade.getCompletion(requestCompletion);
        System.debug(message);
        return transformGeneratedClassification(message);
    }

    private static String getModelId() {
        // TODO - As a best practice this model Id would be better stored in a Custom Metadata Type.
        return '9396733b-4617-4db9-9b24-a3fea0fc02d0-ft';
    }

    private static String getPrompt() {
        // TODO - As a best practice prompts would be better located in Custom Metadata Types, 
        // so they are more easily adjustable for easier improvements of the prompt design
        return 'You are an assistant for the Salesforce CRM, your company offers medicine and supplement products. ' + 
        'You are reading the customer needs, and translating them to actions that need to be performed ' + 
        'in Salesforce, such as the creation of new contacts, tasks, opportunities or products. ' + 
        'You will provide the information following a JSON format. In the following phrases you ' + 
        'will have the conversation between the support representative and the customer: {0}';
    }

    @TestVisible
    private static CallClassificationDTO transformGeneratedClassification(String message) {
        Map<String, Object> classificationMap = (Map<String, Object>) JSON.deserializeUntyped(message);
        CallClassificationDTO callClassificationDTO = new CallClassificationDTO();
        callClassificationDTO.opportunities = transformOpportunities((List<Object>) classificationMap.get('opportunities'));
        callClassificationDTO.tasks = transformTasks((List<Object>) classificationMap.get('tasks'));
        callClassificationDTO.products = transformProducts((List<Object>) classificationMap.get('products'));
        callClassificationDTO.contacts = transformContacts((List<Object>) classificationMap.get('contacts'));
        return callClassificationDTO;
    }

    public static List<Opportunity> transformOpportunities(List<Object> untypedOpportunities) {
        List<Opportunity> typedOpportunities = new List<Opportunity>();
        for (Object untypedOpportunity : untypedOpportunities) {
            Opportunity opportunity = new Opportunity();
            Map<String, Object> untypedOpportunityMap = (Map<String, Object>) untypedOpportunity;
            opportunity.Name = (String) untypedOpportunityMap.get('Name');
            opportunity.Description = (String) untypedOpportunityMap.get('Description');
            typedOpportunities.add(opportunity);
        }
        return typedOpportunities;
    }

    public static List<Task> transformTasks(List<Object> untypedTasks) {
        List<Task> typedTasks = new List<Task>();
        for (Object untypedTask : untypedTasks) {
            Task task = new Task();
            Map<String, Object> untypedTaskMap = (Map<String, Object>) untypedTask;
            task.Description = (String) untypedTaskMap.get('Description');
            typedTasks.add(task);
        }
        return typedTasks;
    }

    public static List<Product2> transformProducts(List<Object> untypedProducts) {
        List<Product2> typedProducts = new List<Product2>();
        for (Object untypedProduct : untypedProducts) {
            Product2 product = new Product2();
            Map<String, Object> untypedProductMap = (Map<String, Object>) untypedProduct;
            product.Name = (String) untypedProductMap.get('Name');
            typedProducts.add(product);
        }
        return typedProducts;
    }

    private static List<Contact> transformContacts(List<Object> untypedContacts) {
        List<Contact> typedContacts = new List<Contact>();
        for (Object untypedContact : untypedContacts) {
            Contact contact = new Contact();
            Map<String, Object> untypedContactMap = (Map<String, Object>) untypedContact;
            contact.FirstName = (String) untypedContactMap.get('FirstName');
            contact.LastName = (String) untypedContactMap.get('LastName');
            contact.Email = (String) untypedContactMap.get('Email');
            contact.Phone = (String) untypedContactMap.get('Phone');
            contact.MailingStreet = (String) untypedContactMap.get('Address');
            typedContacts.add(contact);
        }
        return typedContacts;
    }

    public class CallClassificationDTO {
        @AuraEnabled public List<Contact> contacts;
        @AuraEnabled public List<Opportunity> opportunities;
        @AuraEnabled public List<Task> tasks;
        @AuraEnabled public List<Product2> products;
    }

}