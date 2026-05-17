#!/usr/bin/env bash
# End-to-end smoke: mock upstream + YARP proxy (requires two terminals or background jobs).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

cleanup() {
  [[ -n "${MOCK_PID:-}" ]] && kill "$MOCK_PID" 2>/dev/null || true
  [[ -n "${PROXY_PID:-}" ]] && kill "$PROXY_PID" 2>/dev/null || true
}
trap cleanup EXIT

dotnet build -c Release --no-restore >/dev/null 2>&1 || dotnet build -c Release

dotnet run --project src/TensorGate.MockUpstream/TensorGate.MockUpstream.csproj \
  --urls "http://127.0.0.1:9090" --no-launch-profile &
MOCK_PID=$!
sleep 2

dotnet run --project src/TensorGate.Proxy/TensorGate.Proxy.csproj \
  --urls "http://127.0.0.1:8080" --no-launch-profile &
PROXY_PID=$!
sleep 3

curl -fsS "http://127.0.0.1:8080/health" >/dev/null
curl -fsS "http://127.0.0.1:8080/v1/models" | grep -q mock-upstream

echo "YARP smoke test passed."
