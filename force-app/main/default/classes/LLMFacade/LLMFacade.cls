public with sharing class LLMFacade {
 
    public static String getAudioTranscript(Blob rawAudio) {
        IDeepTranscriptConnector iDeepTranscriptConnector = DeepgramConnector.getInstance();
        return iDeepTranscriptConnector.listen(rawAudio);
    }

    public static LLMDTO.Message getChatCompletion(List<LLMDTO.Message> messages) {
        ILLMConnector iLLMConnector = OpenAIConnector.getInstance();
        return iLLMConnector.getChatCompletion(messages);
    }

}