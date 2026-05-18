{
  den.aspects.opencode = {
    homeManager = {
      pkgs,
      lib,
      ...
    }: {
      programs.opencode = {
        enable = true;
        settings = {
          provider = {
            ollama = {
              npm = "@ai-sdk/openai-compatible";
              name = "Ollama";
              options = {
                baseURL = "http://localhost:3000/api";
              };
              models = {
                "qwen3.6:35b" = {
                  name = "qwen3.6:35b";
                  reasoning = false;
                  tools = true;
                };
                "gpt-oss:20b" = {
                  name = "gpt-oss:20b";
                  reasoning = false;
                  tools = true;
                };
                "gpt-oss:120b" = {
                  name = "gpt-oss:120b";
                  reasoning = false;
                  tools = true;
                };
              };
            };
          };
        };
      };
    };
  };
}
