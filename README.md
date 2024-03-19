# droplets

## Basics

´´´bash
apt update && apt upgrade -y && curl -fsSL https://tailscale.com/install.sh | sh
```

## Docker Setup

```bash
curl -fsSL https://get.docker.com | sh && apt install docker-compose -y && systemctl enable docker && sudo systemctl start docker
```

## Python Setup

```bash
apt install -y python3 python3-pip python-is-python3
```
