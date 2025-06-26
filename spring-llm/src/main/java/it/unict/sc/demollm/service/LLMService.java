package it.unict.sc.demollm.service;

import it.unict.sc.demollm.dto.LLMRequest;
import it.unict.sc.demollm.dto.LLMResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;

import java.util.List;

@Service
public class LLMService {
    public static final String CHAT_COMPLETIONS = "/v1/chat/completions";
    private final RestTemplate restTemplate;
    private final String baseUrl;

    public LLMService(@Value("${llm.api.base-url}") String baseUrl) {
        this.baseUrl = baseUrl;
        this.restTemplate = new RestTemplate();
    }

    public String invoke(String message) {
        try {
            LLMRequest request = new LLMRequest(List.of(new LLMRequest.Message(message)));
            LLMResponse response = callLLM(request);
            return response.getChoices().getFirst().getMessage().getContent();
        } catch (Exception e) {
            return "LLM server error: " + e.getMessage();
        }
    }

    private LLMResponse callLLM(LLMRequest request) {
        String url = baseUrl + CHAT_COMPLETIONS;
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<LLMRequest> entity = new HttpEntity<>(request, headers);
        return restTemplate.postForObject(url, entity, LLMResponse.class);
    }
}
