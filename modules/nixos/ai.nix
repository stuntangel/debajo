{ pkgs, ... }:
let
  # 1. Define a bleeding-edge version of llama-cpp
  bleeding-edge-llama = pkgs.llama-cpp.overrideAttrs (old: {
    version = "8226";
    src = pkgs.fetchFromGitHub {
      owner = "ggml-org";
      repo = "llama.cpp";
      rev = "b8226"; # Pulls the absolute latest code
      hash = "sha256-Z99C+SbRLimk85cypp98J6kUfiegrQqpDZcLgr/98/I="; # We will let Nix tell us the real hash!
    };
  });
in
{
  environment.systemPackages = with pkgs; [
    bleeding-edge-llama
  ];

  environment.etc."llama-swap/config.yaml".text = ''
    # llama-swap configuration
    # This config uses llama.cpp's server to serve models on demand

    models:  # Ordered from newest to oldest

      # Uploaded 2025-08-04, size 73.1 GB, max ctx: 131072, layers: 46
      "gwen3.5-35B:ud-q4_k_xl":
        cmd: >
          ${bleeding-edge-llama}/bin/llama-server
          -m /home/ryan/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-UD-Q4_K_XL.gguf
          --port ''${PORT}
          --temp 0.7
          --top-p 0.90
          --top-k 40
          --min-p 0.05
          --repeat-penalty 1.1
          --kv-unified
          --fit on
          --ctx-size 8192
          -ngl 25
          --n-cpu-moe 35
          --main-gpu 0
          --split-mode none

    healthCheckTimeout: 600  # 10 minutes for large model download + loading

    # TTL keeps models in memory for specified seconds after last use
    ttl: 3600  # Keep models loaded for 1 hour (like OLLAMA_KEEP_ALIVE)

    # Groups allow running multiple models simultaneously
    groups:
      embedding:
        # Keep embedding model always loaded alongside any other model
        persistent: true  # Prevents other groups from unloading this
        swap: false       # Don't swap models within this group
        exclusive: false  # Don't unload other groups when loading this
        members:
          - "embeddinggemma:300m"
  '';

  systemd.services.llama-swap = {
    description = "llama-swap - OpenAI compatible proxy with automatic model swapping";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = "ryan";
      Group = "users";

      # Tell systemd where to execute the command so the relative 'unsloth/...' paths work.
      # Adjust this path if your models are stored somewhere else!
      WorkingDirectory = "/home/ryan";

      ExecStart = "${pkgs.llama-swap}/bin/llama-swap --config /etc/llama-swap/config.yaml --listen 0.0.0.0:9292 --watch-config";
      Restart = "always";
      RestartSec = 10;
      # Environment for CUDA support
      Environment = [
        "PATH=/run/current-system/sw/bin"
        "LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib"
        "HIP_VISIBLE_DEVICES=0"
        "ROCR_VISIBLE_DEVICES=0" 
        # llama-swap can use both GPUs (0,1), but Ollama is restricted to GPU 0
      ];
      # Environment needs access to cache directories for model downloads
      # Simplified security settings to avoid namespace issues
      PrivateTmp = true;
      NoNewPrivileges = true;
    };
  };
}
