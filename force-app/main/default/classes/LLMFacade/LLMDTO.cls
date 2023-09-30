public with sharing class LLMDTO {

    public class RequestCompletion {
        public String prompt;
        public Decimal temperature;
        public String model;
    }

    public class Message {
        public String responseId;
        public String role;
        public String content;
    }

}