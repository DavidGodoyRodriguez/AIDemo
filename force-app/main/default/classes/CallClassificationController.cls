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
    public static string queryAudioTranscription(Id contentDocumentId){
        try {

            

            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}