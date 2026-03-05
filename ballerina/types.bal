// Copyright (c) 2025 WSO2 LLC (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

# Configurations for controlling the behaviours when communicating with a remote HTTP endpoint.
@display {label: "Connection Configuration"}
public type ConnectionConfig record {|

    # The HTTP version understood by the client
    @display {label: "HTTP Version"}
    http:HttpVersion httpVersion = http:HTTP_2_0;

    # Configurations related to HTTP/1.x protocol
    @display {label: "HTTP1 Settings"}
    http:ClientHttp1Settings http1Settings?;

    # Configurations related to HTTP/2 protocol
    @display {label: "HTTP2 Settings"}
    http:ClientHttp2Settings http2Settings?;

    # The maximum time to wait (in seconds) for a response before closing the connection
    @display {label: "Timeout"}
    decimal timeout = 60;

    # The choice of setting `forwarded`/`x-forwarded` header
    @display {label: "Forwarded"}
    string forwarded = "disable";

    # Configurations associated with request pooling
    @display {label: "Pool Configuration"}
    http:PoolConfiguration poolConfig?;

    # HTTP caching related configurations
    @display {label: "Cache Configuration"}
    http:CacheConfig cache?;

    # Specifies the way of handling compression (`accept-encoding`) header
    @display {label: "Compression"}
    http:Compression compression = http:COMPRESSION_AUTO;

    # Configurations associated with the behaviour of the Circuit Breaker
    @display {label: "Circuit Breaker Configuration"}
    http:CircuitBreakerConfig circuitBreaker?;

    # Configurations associated with retrying
    @display {label: "Retry Configuration"}
    http:RetryConfig retryConfig?;

    # Configurations associated with inbound response size limits
    @display {label: "Response Limit Configuration"}
    http:ResponseLimitConfigs responseLimits?;

    # SSL/TLS-related options
    @display {label: "Secure Socket Configuration"}
    http:ClientSecureSocket secureSocket?;

    # Proxy server related options
    @display {label: "Proxy Configuration"}
    http:ProxyConfig proxy?;

    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    @display {label: "Payload Validation"}
    boolean validation = true;
|};

# Model names available through the OpenRouter unified API.
# OpenRouter model IDs use the format `provider/model-name`.
@display {label: "OpenRouter Model Names"}
public enum OPENROUTER_MODEL_NAMES {
    # OpenAI GPT-4o — flagship multimodal model
    OPENAI_GPT_4O = "openai/gpt-4o",
    # OpenAI GPT-4o Mini — fast and affordable
    OPENAI_GPT_4O_MINI = "openai/gpt-4o-mini",
    # OpenAI GPT-4.1 — latest GPT-4 variant
    OPENAI_GPT_4_1 = "openai/gpt-4.1",
    # OpenAI o1 — reasoning model
    OPENAI_O1 = "openai/o1",
    # OpenAI o3 mini — efficient reasoning model
    OPENAI_O3_MINI = "openai/o3-mini",
    # Anthropic Claude 3.5 Sonnet — highly capable
    ANTHROPIC_CLAUDE_3_5_SONNET = "anthropic/claude-3.5-sonnet",
    # Anthropic Claude 3.5 Haiku — fast and affordable
    ANTHROPIC_CLAUDE_3_5_HAIKU = "anthropic/claude-3.5-haiku",
    # Anthropic Claude 3 Opus — most powerful Claude 3
    ANTHROPIC_CLAUDE_3_OPUS = "anthropic/claude-3-opus",
    # Anthropic Claude Sonnet 4 — latest Claude
    ANTHROPIC_CLAUDE_SONNET_4 = "anthropic/claude-sonnet-4",
    # Google Gemini Pro 1.5 — long context model
    GOOGLE_GEMINI_PRO_1_5 = "google/gemini-pro-1.5",
    # Google Gemini Flash 1.5 — fast and efficient
    GOOGLE_GEMINI_FLASH_1_5 = "google/gemini-flash-1.5",
    # Google Gemini Flash 2.0 — latest flash model
    GOOGLE_GEMINI_FLASH_2_0 = "google/gemini-2.0-flash-001",
    # Meta Llama 3.1 8B Instruct — small open model
    META_LLAMA_3_1_8B = "meta-llama/llama-3.1-8b-instruct",
    # Meta Llama 3.1 70B Instruct — mid-size open model
    META_LLAMA_3_1_70B = "meta-llama/llama-3.1-70b-instruct",
    # Meta Llama 3.1 405B Instruct — largest open model
    META_LLAMA_3_1_405B = "meta-llama/llama-3.1-405b-instruct",
    # Meta Llama 3.3 70B Instruct — latest Llama 3.3
    META_LLAMA_3_3_70B = "meta-llama/llama-3.3-70b-instruct",
    # Mistral 7B Instruct — efficient open model
    MISTRAL_7B = "mistralai/mistral-7b-instruct",
    # Mistral Large — Mistral's flagship model
    MISTRAL_LARGE = "mistralai/mistral-large",
    # Mixtral 8x7B Instruct — mixture-of-experts model
    MIXTRAL_8X7B = "mistralai/mixtral-8x7b-instruct",
    # DeepSeek Chat — strong open-source model
    DEEPSEEK_CHAT = "deepseek/deepseek-chat",
    # Microsoft Phi-3 Mini — small but capable model
    MICROSOFT_PHI_3_MINI = "microsoft/phi-3-mini-128k-instruct",
    # Free tier: Meta Llama 3.1 8B (no cost)
    META_LLAMA_3_1_8B_FREE = "meta-llama/llama-3.1-8b-instruct:free"
}

type ToolInfo readonly & record {|
    string toolList;
    string toolIntro;
|};

type LlmChatResponse record {|
    string content;
|};
