# Local Environment Setup

## Requirements

Install the required tools:

### Kind

#### Linux

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

#### macOS

```bash
brew install kind
```

### Kubectl

#### Linux

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

#### macOS

```bash
brew install kubectl
```

---

## 1. Create the Kind Cluster

```bash
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
 - role: control-plane
   kubeadmConfigPatches:
   - |
     kind: InitConfiguration
     nodeRegistration:
       kubeletExtraArgs:
         node-labels: "ingress-ready=true"
   extraPortMappings:
   - containerPort: 80
     hostPort: 80
     protocol: TCP
   - containerPort: 443
     hostPort: 443
     protocol: TCP
EOF
```

---

## 2. Install NGINX Ingress

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

---

## 3. Configure Local Domains

Add the following entries to `/etc/hosts`:

```text
127.0.0.1 movie-rater.local
127.0.0.1 auth.movie-rater.local
```

---

## 4. Generate TLS Certificates

### Linux

```bash
sudo apt install mkcert
```

### macOS

```bash
brew install mkcert
```

```bash
mkcert --install
mkcert movie-rater.local auth.movie-rater.local
```

---

## 5. Create the TLS Secret

```bash
kubectl create secret tls tls-secret \
  -n movie-rater \
  --cert=movie-rater.local+1.pem \
  --key=movie-rater.local+1-key.pem
```

---

## 6. Start the Application

```bash
./run
```

Once the application is running:

- Application: https://movie-rater.local
- Keycloak: https://auth.movie-rater.local

---

# Keycloak Configuration

## Admin Panel Login

```text
URL: https://auth.movie-rater.local
login: admin
password: admin
```

---

## Realm Configuration

1. Create a realm:

```text
movie-rater
```

---

## Client Configuration

1. Create a client:

```text
frontend-client
```

2. Configure it as follows:

- OpenID Connect
- Client authentication: OFF
- PKCE: S256 REQUIRED
- Redirect URI:

```text
https://movie-rater.local/*
```

- Web Origins:

```text
https://movie-rater.local
```

---

## User Registration

In the realm:

```text
Realm Settings → Login → User registration = ON
```

---

## Roles

1. Create the following role:

```text
admin
```

2. Assign it to a user under:

```text
Users → Role mapping
```

---

# Backend Secrets

In the following file:

```text
backend-secrets.yaml
```

set the RS256 public key in Base64 format:

```bash
echo -n "<YOUR_RS256_PUBLIC_KEY>" | base64
```

Paste the output into the `secret` section as the value of the corresponding field.