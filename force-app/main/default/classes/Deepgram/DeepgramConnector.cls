public with sharing class DeepgramConnector implements IDeepTranscriptConnector {
    public class DeepgramConnectorException extends Exception {}
    
    private static IDeepTranscriptConnector deepgramConnectorInstance;

    public static IDeepTranscriptConnector getInstance() {
        if (deepgramConnectorInstance == null) {
            deepgramConnectorInstance = new DeepgramConnector();
        }
        return deepgramConnectorInstance;
    }

    public String listen(Blob rawAudio) {

        HttpRequest httpRequest = new HttpRequest();
        // redact=true - Hides sensitive information
        httpRequest.setEndpoint('callout:Deepgram/v1/listen?model=nova&punctuate=true&profanity=true&diarize=true&smart_format=true');
        httpRequest.setMethod('POST');

        httpRequest.setBodyAsBlob(rawAudio);

        Http http = new Http();
        HTTPResponse httpResponse = http.send(httpRequest);
        validateHttpResponse(httpResponse);
        return getFormattedTranscript(httpResponse.getBody());
    }

    private void validateHttpResponse(HTTPResponse httpResponse) {
        if (httpResponse.getStatusCode() != 200) {
            throw new DeepgramConnectorException('Deepgram callout failed with code: ' + httpResponse.getStatusCode() + ', message: ' + httpResponse.getBody());
        }
    }

    private String getFormattedTranscript(String deepgramResponse) {

        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(deepgramResponse);

        if (data.containsKey('results')) {
            Map<String, Object> results = (Map<String, Object>) data.get('results');
            if (results.containsKey('channels')) {
                List<Object> channels = (List<Object>) results.get('channels');
                // We are only expecting 1 Channel in this implementation.
                Map<String, Object> channel = (Map<String, Object>) channels.get(0);
                if (channel.containsKey('alternatives')) {
                    List<Object> alternatives = (List<Object>) channel.get('alternatives');
                    // We are only expecting 1 Alternative in this implementation.
                    Map<String, Object> alternative = (Map<String, Object>) alternatives.get(0);
                    if (alternative.containsKey('paragraphs')) {
                        Map<String, Object> paragraphs = (Map<String, Object>) alternative.get('paragraphs');
                        if (paragraphs.containsKey('transcript')) {
                            return (String) paragraphs.get('transcript');
                        }
                    }
                }
            }
        }

        return null;
    }

}