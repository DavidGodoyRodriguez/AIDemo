public with sharing class LLMFacade {
 
    public static String getAudioTranscript(Blob rawAudio) {
        IDeepTranscriptConnector iDeepTranscriptConnector = DeepgramConnector.getInstance();
        return iDeepTranscriptConnector.listen(rawAudio);
    }

    public static String getCompletion(LLMDTO.RequestCompletion requestCompletion) {
        ILLMConnector iLLMConnector = CohereConnector.getInstance();
        return iLLMConnector.getCompletion(requestCompletion);
    }

    public static LLMDTO.Message getChatCompletion(List<LLMDTO.Message> messages) {
        ILLMConnector iLLMConnector = CohereConnector.getInstance();
        return iLLMConnector.getChatCompletion(messages);
    }

    public static String getAssistantRole() {
        ILLMConnector iLLMConnector = CohereConnector.getInstance();
        return iLLMConnector.getAssistantRole();
    }

    public static String getUserRole() {
        ILLMConnector iLLMConnector = CohereConnector.getInstance();
        return iLLMConnector.getUserRole();
    }

}