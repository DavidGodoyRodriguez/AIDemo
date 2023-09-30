public interface ILLMConnector {
    String getCompletion(LLMDTO.RequestCompletion requestCompletion);
    LLMDTO.Message getChatCompletion(List<LLMDTO.Message> messages);
    Boolean hasSystemRole();
    String getSystemRole();
    String getAssistantRole();
    String getUserRole();
}