# Ballerina OpenRouter Model Provider

## Overview

[OpenRouter](https://openrouter.ai) is a unified API gateway that provides access to 200+ Large Language
Models from leading AI providers including OpenAI (GPT-4o, o1), Anthropic (Claude 3.5 Sonnet, Claude 3 Opus),
Google (Gemini Pro, Gemini Flash), Meta (Llama 3.1), Mistral (Mixtral, Mistral Large), and many more —
all through a single OpenAI-compatible API.

The `ballerinax/ai.openrouter` package provides a Ballerina model provider that integrates with the
[Ballerina AI framework](https://central.ballerina.io/ballerina/ai/latest), enabling you to use any
OpenRouter-supported model in your Ballerina AI agents and applications.

## Prerequisites

Before using this module in your Ballerina application, you must first:

1. Create an [OpenRouter account](https://openrouter.ai/signup).
2. Obtain an API key from [https://openrouter.ai/keys](https://openrouter.ai/keys).

## Quickstart

### Step 1: Import the module

```ballerina
import ballerina/ai;
import ballerinax/ai.openrouter;
```

### Step 2: Initialize the Model Provider

```ballerina
// Initialize with Anthropic Claude 3.5 Sonnet via OpenRouter
final ai:ModelProvider model = check new openrouter:ModelProvider(
    apiKey = "<OPENROUTER_API_KEY>",
    modelType = openrouter:ANTHROPIC_CLAUDE_3_5_SONNET,
    siteUrl = "https://my-app.example.com",   // Optional: for OpenRouter attribution
    siteName = "My Ballerina App"              // Optional: for OpenRouter attribution
);
```

### Step 3: Chat with the model

```ballerina
import ballerina/io;

public function main() returns error? {
    ai:ChatMessage[] messages = [
        {role: ai:USER, content: "What are the benefits of functional programming?"}
    ];

    ai:ChatAssistantMessage response = check model->chat(messages, []);
    io:println("Assistant: ", response.content);
}
```

### Step 4: Generate structured output

For generating structured (typed) output, annotate your record type with `@ai:JsonSchema`:

```ballerina
type BlogReview record {|
    int rating;
    string summary;
    string[] highlights;
|};

@ai:JsonSchema {
    "type": "object",
    "required": ["rating", "summary", "highlights"],
    "properties": {
        "rating": {"type": "integer", "minimum": 1, "maximum": 10},
        "summary": {"type": "string"},
        "highlights": {"type": "array", "items": {"type": "string"}}
    }
}
type BlogReviewType BlogReview;

BlogReview|error review = model->generate(
    `Review the following blog post and rate it out of 10.
     Title: ${blogTitle}
     Content: ${blogContent}`
);
```

### Step 5: Use with AI Agents

```ballerina
import ballerina/ai;
import ballerinax/ai.openrouter;

@ai:Tool {description: "Get the current weather for a given city"}
function getCurrentWeather(string city) returns string {
    return string `The weather in ${city} is sunny and 25°C`;
}

public function main() returns error? {
    openrouter:ModelProvider model = check new (
        apiKey = "<OPENROUTER_API_KEY>",
        modelType = openrouter:OPENAI_GPT_4O
    );

    ai:FunctionCallAgent agent = check new (model, getCurrentWeather);
    string result = check agent->run("What is the weather in Colombo?");
}
```

## Supported Models

The following models are available as enum constants (see `OPENROUTER_MODEL_NAMES`):

| Constant | Model ID | Provider |
|---|---|---|
| `OPENAI_GPT_4O` | `openai/gpt-4o` | OpenAI |
| `OPENAI_GPT_4O_MINI` | `openai/gpt-4o-mini` | OpenAI |
| `ANTHROPIC_CLAUDE_3_5_SONNET` | `anthropic/claude-3.5-sonnet` | Anthropic |
| `ANTHROPIC_CLAUDE_3_5_HAIKU` | `anthropic/claude-3.5-haiku` | Anthropic |
| `ANTHROPIC_CLAUDE_SONNET_4` | `anthropic/claude-sonnet-4` | Anthropic |
| `GOOGLE_GEMINI_PRO_1_5` | `google/gemini-pro-1.5` | Google |
| `GOOGLE_GEMINI_FLASH_2_0` | `google/gemini-2.0-flash-001` | Google |
| `META_LLAMA_3_1_70B` | `meta-llama/llama-3.1-70b-instruct` | Meta |
| `META_LLAMA_3_3_70B` | `meta-llama/llama-3.3-70b-instruct` | Meta |
| `MISTRAL_LARGE` | `mistralai/mistral-large` | Mistral AI |
| `DEEPSEEK_CHAT` | `deepseek/deepseek-chat` | DeepSeek |
| `META_LLAMA_3_1_8B_FREE` | `meta-llama/llama-3.1-8b-instruct:free` | Meta (free tier) |

You can also specify any OpenRouter model ID as a string, since `OPENROUTER_MODEL_NAMES` is an enum of strings.

## Configuration

| Parameter | Type | Required | Description |
|---|---|---|---|
| `apiKey` | `string` | Yes | OpenRouter API key |
| `modelType` | `OPENROUTER_MODEL_NAMES` | Yes | Model to use |
| `serviceUrl` | `string` | No | Override API base URL (default: `https://openrouter.ai/api/v1`) |
| `siteUrl` | `string?` | No | Your site URL for OpenRouter attribution (`HTTP-Referer` header) |
| `siteName` | `string?` | No | Your site name for OpenRouter attribution (`X-Title` header) |
| `maxTokens` | `int` | No | Maximum tokens in response (default: 512) |
| `temperature` | `decimal` | No | Response randomness, 0.0–2.0 (default: 0.7) |
| `connectionConfig` | `ConnectionConfig` | No | HTTP connection settings |

## Links

- [OpenRouter Dashboard](https://openrouter.ai)
- [API Keys](https://openrouter.ai/keys)
- [Available Models](https://openrouter.ai/models)
- [Ballerina AI Framework](https://central.ballerina.io/ballerina/ai/latest)
