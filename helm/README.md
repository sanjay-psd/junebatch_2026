# Java Web Blue-Green Deployment Helm Chart

A Helm chart for deploying Java Web applications with blue-green deployment strategy on Kubernetes.

## Installation

```bash
# Install the chart
helm install java-web-release ./helm

# Install with custom values
helm install java-web-release ./helm -f custom-values.yaml

# Install in specific namespace
helm install java-web-release ./helm -n java-web-namespace
```

## Usage

### Deploy to Active Version (Green)
```bash
helm install java-web-release ./helm
# or upgrade to switch versions
helm upgrade java-web-release ./helm
```

### Switch Traffic to Blue
```bash
helm upgrade java-web-release ./helm --set service.main.activeVersion=blue
```

### Switch Traffic to Green
```bash
helm upgrade java-web-release ./helm --set service.main.activeVersion=green
```

### Disable One Deployment
```bash
# Disable blue deployment (keep only green)
helm upgrade java-web-release ./helm --set blue.enabled=false

# Disable green deployment (keep only blue)
helm upgrade java-web-release ./helm --set green.enabled=false
```

## Configuration

### Key Values

| Parameter | Default | Description |
|-----------|---------|-------------|
| `namespace.name` | `java-web-namespace` | Kubernetes namespace |
| `namespace.create` | `true` | Create namespace if it doesn't exist |
| `blue.enabled` | `true` | Enable blue deployment |
| `blue.deployment.replicaCount` | `2` | Number of blue replicas |
| `blue.image.repository` | `jatinbhalla1991/java-web-blue` | Blue image repository |
| `blue.image.tag` | `v1.0` | Blue image tag |
| `green.enabled` | `true` | Enable green deployment |
| `green.deployment.replicaCount` | `2` | Number of green replicas |
| `green.image.repository` | `jatinbhalla1991/java-web-green` | Green image repository |
| `green.image.tag` | `v2.0` | Green image tag |
| `service.main.activeVersion` | `green` | Active service version (blue or green) |

## Commands

### List releases
```bash
helm list
```

### Uninstall
```bash
helm uninstall java-web-release
```

### Dry run (preview changes)
```bash
helm install java-web-release ./helm --dry-run --debug
helm upgrade java-web-release ./helm --dry-run --debug
```

### Get release values
```bash
helm get values java-web-release
```

### History
```bash
helm history java-web-release
helm rollback java-web-release 1  # Rollback to previous version
```

## Blue-Green Deployment Workflow

1. **Initial Deploy**: Both blue (v1.0) and green (v2.0) deployments are running
2. **Route Traffic**: Main service routes to active version (default: green)
3. **Test**: Use `java-web-service-green` for internal testing before switching
4. **Switch**: Update `service.main.activeVersion` to swap traffic
5. **Rollback**: Instant rollback by switching back to previous version

## File Structure

```
helm/
├── Chart.yaml                    # Chart metadata
├── values.yaml                   # Default values
├── README.md                     # This file
└── templates/
    ├── namespace.yaml            # Kubernetes namespace
    ├── deployment-blue.yaml      # Blue deployment
    ├── deployment-green.yaml     # Green deployment
    ├── service.yaml              # Services (main & green)
    └── configmap.yaml            # ConfigMaps with HTML
```

## Switching Traffic Example

```bash
# Currently routing to green
helm upgrade java-web-release ./helm --set service.main.activeVersion=green

# Switch to blue
helm upgrade java-web-release ./helm --set service.main.activeVersion=blue

# Instant rollback to green
helm upgrade java-web-release ./helm --set service.main.activeVersion=green
```

## Troubleshooting

```bash
# Check release status
helm status java-web-release

# View rendered templates
helm template java-web-release ./helm

# Get all resources created
kubectl get all -n java-web-namespace

# Check pod logs
kubectl logs -n java-web-namespace -l version=green
```

## Notes

- ConfigMaps contain embedded HTML files for blue and green environments
- Blue environment: blue gradient background (v1.0)
- Green environment: green gradient background (v2.0)
- Services automatically route to selected version via label selectors
- Zero-downtime deployments with instant rollback capability
