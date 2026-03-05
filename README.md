# Ballerina OpenRouter Model Provider Library

[![Build](https://github.com/ballerina-platform/module-ballerinax-ai.openrouter/workflows/CI/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-ai.openrouter/actions?query=workflow%3ACI)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-ai.openrouter.svg)](https://github.com/ballerina-platform/module-ballerinax-ai.openrouter/commits/main)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview

[OpenRouter](https://openrouter.ai) is a unified API gateway that provides access to **200+ Large Language
Models** from leading AI providers through a single, OpenAI-compatible API. This module provides a
Ballerina model provider that integrates OpenRouter with the Ballerina AI framework.

Supported providers include:
- **OpenAI** — GPT-4o, GPT-4.1, o1, o3-mini
- **Anthropic** — Claude 3.5 Sonnet, Claude 3.5 Haiku, Claude 3 Opus, Claude Sonnet 4
- **Google** — Gemini Pro 1.5, Gemini Flash 1.5/2.0
- **Meta** — Llama 3.1 (8B, 70B, 405B), Llama 3.3 70B
- **Mistral AI** — Mistral Large, Mixtral 8x7B, Mistral 7B
- **DeepSeek** — DeepSeek Chat
- **Microsoft** — Phi-3 Mini
- And [200+ more models](https://openrouter.ai/models)

## Prerequisites

1. Create an [OpenRouter account](https://openrouter.ai/signup).
2. Get an API key from [https://openrouter.ai/keys](https://openrouter.ai/keys).

## Installation

Add the dependency to your `Ballerina.toml`:

```toml
[[dependency]]
org = "ballerinax"
name = "ai.openrouter"
version = "1.0.0"
```

Or run:

```bash
bal add ballerinax/ai.openrouter
```

## Quick Start

```ballerina
import ballerina/ai;
import ballerina/io;
import ballerinax/ai.openrouter;

public function main() returns error? {
    // Initialize with any OpenRouter model
    openrouter:ModelProvider model = check new (
        apiKey = "<OPENROUTER_API_KEY>",
        modelType = openrouter:ANTHROPIC_CLAUDE_3_5_SONNET,
        siteUrl = "https://my-app.com",     // Optional: for attribution
        siteName = "My Ballerina App"        // Optional: for attribution
    );

    // Chat completion
    ai:ChatMessage[] messages = [
        {role: ai:USER, content: "Explain Ballerina's concurrency model in 2 sentences."}
    ];
    ai:ChatAssistantMessage response = check model->chat(messages, []);
    io:println(response.content);
}
```

## Usage Examples

### Basic Chat

```ballerina
import ballerina/ai;
import ballerinax/ai.openrouter;

final openrouter:ModelProvider model = check new (
    apiKey = "<OPENROUTER_API_KEY>",
    modelType = openrouter:OPENAI_GPT_4O
);

public function main() returns error? {
    ai:ChatMessage[] messages = [
        {role: ai:SYSTEM, content: "You are a helpful assistant."},
        {role: ai:USER, content: "What is the capital of France?"}
    ];
    ai:ChatAssistantMessage reply = check model->chat(messages, []);
    // reply.content == "Paris"
}
```

### Structured Output Generation

For `generate`, use `@ai:JsonSchema` for complex record types:

```ballerina
import ballerina/ai;
import ballerinax/ai.openrouter;

type ProductAnalysis record {|
    string name;
    int rating;
    string[] pros;
    string[] cons;
|};

@ai:JsonSchema {
    "type": "object",
    "required": ["name", "rating", "pros", "cons"],
    "properties": {
        "name": {"type": "string"},
        "rating": {"type": "integer", "minimum": 1, "maximum": 10},
        "pros": {"type": "array", "items": {"type": "string"}},
        "cons": {"type": "array", "items": {"type": "string"}}
    }
}
type ProductAnalysisType ProductAnalysis;

final openrouter:ModelProvider model = check new (
    "<OPENROUTER_API_KEY>",
    openrouter:OPENAI_GPT_4O
);

public function main() returns error? {
    ProductAnalysis analysis = check model->generate(
        `Analyze the following product: "iPhone 16 Pro - Apple's latest flagship smartphone."`
    );
    // analysis.name, analysis.rating, analysis.pros, analysis.cons are populated
}
```

For basic types, no annotation is needed:

```ballerina
int rating = check model->generate(`Rate this product out of 10: "MacBook Pro M4"`);
string summary = check model->generate(`Summarize in one sentence: "${longText}"`);
boolean isPositive = check model->generate(`Is this review positive? "${reviewText}"`);
```

### Using with Ballerina AI Agents

```ballerina
import ballerina/ai;
import ballerinax/ai.openrouter;

@ai:Tool {description: "Search the web for current information"}
function webSearch(string query) returns string {
    // Your search implementation
    return "Search results for: " + query;
}

@ai:Tool {description: "Get the current date and time"}
function getCurrentTime() returns string {
    return "2025-03-05 14:30:00 UTC";
}

public function main() returns error? {
    openrouter:ModelProvider model = check new (
        apiKey = "<OPENROUTER_API_KEY>",
        modelType = openrouter:META_LLAMA_3_3_70B
    );

    ai:FunctionCallAgent agent = check new (model, webSearch, getCurrentTime);
    string result = check agent->run("What are the latest news about AI today?");
}
```

### Free Models

OpenRouter provides free-tier access to some models. Use the `:free` suffix:

```ballerina
openrouter:ModelProvider model = check new (
    apiKey = "<OPENROUTER_API_KEY>",
    modelType = openrouter:META_LLAMA_3_1_8B_FREE  // Free tier!
);
```

## Configuration Reference

### `ModelProvider.init` Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `apiKey` | `string` | Required | OpenRouter API key |
| `modelType` | `OPENROUTER_MODEL_NAMES` | Required | Model to use |
| `serviceUrl` | `string` | `https://openrouter.ai/api/v1` | API base URL |
| `siteUrl` | `string?` | `()` | Your site URL (`HTTP-Referer` header) |
| `siteName` | `string?` | `()` | Your app name (`X-Title` header) |
| `maxTokens` | `int` | `512` | Max tokens in response |
| `temperature` | `decimal` | `0.7` | Randomness (0.0–2.0) |
| `connectionConfig` | `ConnectionConfig` | Default | HTTP connection settings |

### `ConnectionConfig` Fields

| Field | Type | Default | Description |
|---|---|---|---|
| `httpVersion` | `http:HttpVersion` | `HTTP_2_0` | HTTP protocol version |
| `timeout` | `decimal` | `60` | Request timeout in seconds |
| `retryConfig` | `http:RetryConfig?` | `()` | Retry configuration |
| `circuitBreaker` | `http:CircuitBreakerConfig?` | `()` | Circuit breaker settings |
| `secureSocket` | `http:ClientSecureSocket?` | `()` | TLS/SSL settings |

## Available Models

See the `OPENROUTER_MODEL_NAMES` enum in `types.bal` for the full list of built-in model constants.
For the complete list of all available models (300+), visit [https://openrouter.ai/models](https://openrouter.ai/models).

## Build from Source

### Prerequisites

- [Ballerina Swan Lake distribution](https://ballerina.io/downloads/) 2201.12.0 or later
- OpenRouter API key for integration tests

### Build

```bash
cd ballerina
bal build
```

### Test

```bash
cd ballerina
bal test
```

## Issues and Projects

To report bugs or request features, open an issue at the repository.

## Contributing

Contributions are welcome! Please read the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## License

This module is licensed under the [Apache License 2.0](LICENSE).
