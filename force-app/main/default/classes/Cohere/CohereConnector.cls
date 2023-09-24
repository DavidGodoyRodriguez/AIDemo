public with sharing class CohereConnector implements ILLMConnector {
    private static ILLMConnector cohereConnectorInstance;

    public static ILLMConnector getInstance() {
        if (cohereConnectorInstance == null) {
            cohereConnectorInstance = new CohereConnector();
        }
        return cohereConnectorInstance;
    }

    public LLMDTO.Message getChatCompletion(List<LLMDTO.Message> messages) {
        HttpRequest httpRequest = getHttpRequest();
        httpRequest.setEndpoint('');
        httpRequest.setMethod('POST');
        httpRequest.setBody(buildBodyChatMessages(messages));
        Http http = new Http();
        HTTPResponse httpResponse = http.send(httpRequest);
        validateHttpResponse(httpResponse);
        return trasformIntoLLMMessage(httpResponse.getBody());
    }

    private HttpRequest getHttpRequest() {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('Authorization', getToken());
        return httpRequest;
    }

    private String getToken() {
        return Token__mdt.getInstance('Cohere').Token__c;
    }


    private String buildBodyChatMessages(List<LLMDTO.Message> messages) {
        Map<String, Object> bodyMap = new Map<String, Object>();
        bodyMap.put('model', CHAT_MODEL);
        bodyMap.put('messages', messages);
        return JSON.serialize(bodyMap);
    }

    private void validateHttpResponse(HTTPResponse httpResponse) {
        if (httpResponse.getStatusCode() != 200) {
            throw new OpenAIConnectorException('Cohere callout failed with code: ' + httpResponse.getStatusCode() + ', message: ' + httpResponse.getBody());
        }
    }

    private LLMDTO.Message trasformIntoLLMMessage(String responseBody) {
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        LLMDTO.Message message = new LLMDTO.Message();
        message.content = (String) responseMap.get('text');
        message.responseId = (String) responseMap.get('response_id');
        return message;
    }

}