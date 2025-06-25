{config, ...}: {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1103";
      OLLAMA_CONTEXT_LENGTH = "16384";
      OLLAMA_FLASH_ATTENTION = "true";
      OLLAMA_KV_CACHE_TYPE = "q4_0";
      OLLAMA_API_BASE = "http://127.0.0.1:11434";
    };
    rocmOverrideGfx = "11.0.0";
  };
}
