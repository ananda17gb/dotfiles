# Auto-start Docker daemon on demand via GUI authentication
docker() {
  if ! systemctl is-active --quiet docker.service; then
    echo "⚡ Launching Docker (GUI authentication required)..."
    pkexec systemctl start containerd.service docker.service docker.socket
  fi
  command docker "$@"
}

# Stop Docker using GUI authentication
docker-stop() {
  echo "🛑 Stopping Docker..."
  pkexec systemctl stop docker.service docker.socket containerd.service
  echo "Docker services stopped."
}
