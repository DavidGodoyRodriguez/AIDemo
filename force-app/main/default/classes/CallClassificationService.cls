public with sharing class CallClassificationService {

    public static void classifyCall(List<String> transcribedAudioList){
        String transcribedAudio = String.join(transcribedAudioList, '');

        LLMDTO.RequestCompletion requestCompletion = new LLMDTO.RequestCompletion();
        requestCompletion.model = getModelId();
        requestCompletion.prompt = String.format(getPrompt(), new List<String>{transcribedAudio});
        requestCompletion.temperature = 0;

        String message = LLMFacade.getCompletion(requestCompletion);

        System.debug(message);
    }

    private static String getModelId() {
        // TODO - As a best practice this model Id would be better stored in a Custom Metadata Type.
        return '1515b4d8-c5e9-4fc8-b622-891629051b55-ft';
    }

    private static String getPrompt() {
        return 'You are an assistant for the Salesforce CRM, your company offers medicine and supplement products. ' + 
        'You are reading the customer needs, and translating them to actions that need to be performed ' + 
        'in Salesforce, such as the creation of new contacts, tasks, opportunities or products. ' + 
        'You will provide the information following a JSON format. In the following phrases you ' + 
        'will have the conversation between the support representative and the customer: {0}';
    }

}