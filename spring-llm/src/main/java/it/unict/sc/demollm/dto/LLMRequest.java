package it.unict.sc.demollm.dto;

import lombok.*;

import java.util.List;

@Data
public class LLMRequest {
    private final List<Message> messages;

    @Data
    @RequiredArgsConstructor
    @AllArgsConstructor
    public static class Message {
        private final String content;
        private String role = "user";
    }
}
