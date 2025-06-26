package it.unict.sc.demollm.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class LLMResponse {
    private String id;
    private String object;
    private long created;
    private String model;
    private List<Choice> choices;
    private String systemFingerprint;

    @Data
    @NoArgsConstructor
    public static class Choice {
        private int index;
        private Message message;
        private Object logprobs;
        private String finishReason;
    }

    @Data
    @NoArgsConstructor
    public static class Message {
        private String role;
        private String content;
    }
}
