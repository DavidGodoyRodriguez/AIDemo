public with sharing class CallClassificationController {

    @AuraEnabled
    public static List<ContentDocument> getAudioFiles(Id recordId){
        try {
            List<ContentDocumentLink> contentDocumentLinksList = [
                SELECT Id, ContentDocumentId
                FROM ContentDocumentLink 
                WHERE LinkedEntityId =: recordId
            ];

            Set<Id> contentDocumentIds = new Set<Id>();
            for (ContentDocumentLink contentDocumentLink : contentDocumentLinksList) {
                contentDocumentIds.add(contentDocumentLink.ContentDocumentId);
            }

            return [
                SELECT Id, FileExtension, Title
                FROM ContentDocument
                WHERE Id IN: contentDocumentIds
                AND FileExtension IN ('mp3', 'wav')
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> queryAudioTranscription(Id contentDocumentId){
        try {
            List<ContentVersion> contentVersionList = [
                SELECT VersionData
                FROM ContentVersion 
                WHERE ContentDocumentId =: contentDocumentId
            ];

            if (!contentVersionList.isEmpty()) {
                Blob rawAudio = contentVersionList.get(0).VersionData;
                return getConversationPhrases(LLMFacade.getAudioTranscript(rawAudio));
            }

            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // This method splits in a list each phrase spoken by each speaker
    private static List<String> getConversationPhrases(String audioTranscription) {
        return audioTranscription.split('(?=Speaker \\d:)');
    }

    @AuraEnabled
    public static void classifyCall(List<String> transcribedAudioList){
        try {
            CallClassificationService.classifyCall(transcribedAudioList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}