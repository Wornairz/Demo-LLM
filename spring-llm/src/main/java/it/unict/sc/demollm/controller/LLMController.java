package it.unict.sc.demollm.controller;

import it.unict.sc.demollm.service.LLMService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.Collection;
import java.util.Collections;
import java.util.Map;

@RestController
@RequestMapping("/llm")
public class LLMController {
    @Autowired private LLMService llmService;

    @GetMapping("/chat")
    public String chat(@RequestParam("message") String message) {
        return llmService.invoke(message);
    }

    @PostMapping("/chat")
    public Map<String, String> chatPost(@RequestBody Map<String, String> payload) {
        String message = payload.get("message");
        String response = llmService.invoke(message);
        return Collections.singletonMap("message", response);
    }

}
