public with sharing class CohereConnector implements ILLMConnector {
    private static ILLMConnector cohereConnectorInstance;

    public class CohereConnectorException extends Exception {}
    public class CohereRetryException extends Exception {}

    public static ILLMConnector getInstance() {
        if (cohereConnectorInstance == null) {
            cohereConnectorInstance = new CohereConnector();
        }
        return cohereConnectorInstance;
    }

    public Boolean hasSystemRole() {
        return false;
    }

    public String getSystemRole() {
        return null;
    }

    public String getAssistantRole() {
        return 'Chatbot';
    }

    public String getUserRole() {
        return 'User';
    }

    public String getCompletion(LLMDTO.RequestCompletion requestCompletion) {
        try {
            return sendCompletionRequest(requestCompletion);
        } catch (CohereRetryException exc) {
            if (Limits.getCallouts() < Limits.getLimitCallouts()) {
                return getCompletion(requestCompletion);
            }
            return '';
        }
    }

    private String sendCompletionRequest(LLMDTO.RequestCompletion requestCompletion) {
        HttpRequest httpRequest = getHttpRequest();
        httpRequest.setEndpoint('callout:Cohere/v1/generate');
        httpRequest.setMethod('POST');
        httpRequest.setTimeout(120000);
        httpRequest.setBody(buildBodyCompletion(requestCompletion));
        Http http = new Http();
        HTTPResponse httpResponse = http.send(httpRequest);
        validateHttpResponse(httpResponse);
        return getCompletionMessage(httpResponse.getBody());
    }

    public LLMDTO.Message getChatCompletion(List<LLMDTO.Message> messages) {
        HttpRequest httpRequest = getHttpRequest();
        httpRequest.setEndpoint('callout:Cohere/v1/chat');
        httpRequest.setMethod('POST');
        httpRequest.setBody(buildBodyChatMessages(messages));
        Http http = new Http();
        HTTPResponse httpResponse = http.send(httpRequest);
        validateHttpResponse(httpResponse);
        return trasformIntoLLMMessage(httpResponse.getBody());
    }

    private HttpRequest getHttpRequest() {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setHeader('accept', 'application/json');
        httpRequest.setHeader('content-type', 'application/json');
        return httpRequest;
    }

    private String buildBodyCompletion(LLMDTO.RequestCompletion requestCompletion) {
        Map<String, Object> bodyCompletion = new Map<String, Object>();
        bodyCompletion.put('prompt', requestCompletion.prompt);
        bodyCompletion.put('temperature', requestCompletion.temperature);
        bodyCompletion.put('model', requestCompletion.model);
        bodyCompletion.put('max_tokens', 512);        
        return JSON.serialize(bodyCompletion);
    }

    private String buildBodyChatMessages(List<LLMDTO.Message> messages) {
        Map<String, Object> bodyMap = new Map<String, Object>();
        bodyMap.put('temperature', 0);
        // Get last message to pass to the LLM
        bodyMap.put('message', messages.get(messages.size()-1).content);
        if (messages.size() > 1) {
            bodyMap.put('chat_history', buildChatHistory(messages));
        }
        return JSON.serialize(bodyMap);
    }

    private List<Object> buildChatHistory(List<LLMDTO.Message> messages) {
        List<Object> chatHistory = new List<Object>();
        for (Integer i = 0; i < messages.size() -1; ++i) {
            Map<String, String> chatItem = new Map<String, String>();
            chatItem.put('user_name', messages.get(i).role);
            chatItem.put('message', messages.get(i).content);
            chatHistory.add(chatItem);
        }
        return chatHistory;
    }

    private void validateHttpResponse(HTTPResponse httpResponse) {
        // Looks like the Cohere API for generation is a bit prone to errors, retry the calls
        if (httpResponse.getStatusCode() == 500) {
            throw new CohereRetryException();
        }
        if (httpResponse.getStatusCode() != 200) {
            throw new CohereConnectorException('Cohere callout failed with code: ' + httpResponse.getStatusCode() + ', message: ' + httpResponse.getBody());
        }
    }

    private String getCompletionMessage(String responseBody) {
        Map<String, Object> responseBodyMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        List<Object> generations = (List<Object>) responseBodyMap.get('generations');
        for (Object generationItem : generations) {
            Map<String, Object> generationItemMap = (Map<String, Object>) generationItem;
            return (String) generationItemMap.get('text');
        }
        return '';
    }

    private LLMDTO.Message trasformIntoLLMMessage(String responseBody) {
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        LLMDTO.Message message = new LLMDTO.Message();
        message.responseId = (String) responseMap.get('response_id');
        message.content = (String) responseMap.get('text');
        message.role = getAssistantRole();
        return message;
    }

}