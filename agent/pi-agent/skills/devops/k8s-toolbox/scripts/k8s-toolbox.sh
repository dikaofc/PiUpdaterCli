#!/usr/bin/env bash
# K8s Toolbox — inspect pods, generate manifests, dry-run, diagnose clusters
# Source: https://kubernetes.io/docs/reference/kubectl/
set -euo pipefail

SCRIPT_NAME="k8s-toolbox.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} pods [--all]
       ${SCRIPT_NAME} manifest <kind> <name> [--image IMG] [--port N]
       ${SCRIPT_NAME} dryrun <manifest.yaml>
       ${SCRIPT_NAME} diagnose <namespace>
       ${SCRIPT_NAME} describe <resource> <name> [-n NS]
Inspect a Kubernetes cluster, generate manifests, dry-run apply,
and diagnose issues. Requires kubectl.

Options:
  --all        all namespaces
  --image IMG  container image for manifest generation
  --port N     container/service port
  -n NS        namespace
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
ALL=0
IMAGE="nginx:latest"
PORT="80"
NS="default"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    pods|manifest|dryrun|diagnose|describe) CMD="$1"; shift;;
    --all) ALL=1; shift;;
    --image) IMAGE="$2"; shift 2;;
    --port) PORT="$2"; shift 2;;
    -n) NS="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
: "${KUBECTL:?kubectl not found — install kubectl or set KUBECTL=path}"

case "$CMD" in
  pods)
    if [ "$ALL" = "1" ]; then $KUBECTL get pods --all-namespaces; else $KUBECTL get pods -n "$NS"; fi
    ;;
  manifest)
    KIND="${ARGS[0]:-deployment}"
    NAME="${ARGS[1]:?usage: manifest <kind> <name>}"
    case "$KIND" in
      deployment) cat <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $NAME
  namespace: $NS
spec:
  replicas: 2
  selector:
    matchLabels: { app: $NAME }
  template:
    metadata:
      labels: { app: $NAME }
    spec:
      containers:
        - name: $NAME
          image: $IMAGE
          ports: [{ containerPort: $PORT }]
YAML
        ;;
      service) cat <<YAML
apiVersion: v1
kind: Service
metadata:
  name: $NAME
  namespace: $NS
spec:
  selector: { app: $NAME }
  ports:
    - port: $PORT
      targetPort: $PORT
YAML
        ;;
      pod) cat <<YAML
apiVersion: v1
kind: Pod
metadata:
  name: $NAME
  namespace: $NS
spec:
  containers:
    - name: $NAME
      image: $IMAGE
      ports: [{ containerPort: $PORT }]
YAML
        ;;
      configmap) cat <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: $NAME
  namespace: $NS
data:
  key: value
YAML
        ;;
      *) echo "supported kinds: deployment service pod configmap" >&2; exit 2;;
    esac
    ;;
  dryrun)
    F="${ARGS[0]:?usage: dryrun <manifest.yaml>}"
    [ -f "$F" ] || { echo "not found: $F" >&2; exit 1; }
    $KUBECTL apply --dry-run=client -f "$F"
    $KUBECTL apply --dry-run=server -f "$F" 2>&1 | head -5
    ;;
  diagnose)
    NS_ARG="${ARGS[0]:-$NS}"
    echo "=== pods ==="
    $KUBECTL get pods -n "$NS_ARG"
    echo ""
    echo "=== failing pods ==="
    for p in $($KUBECTL get pods -n "$NS_ARG" --no-headers | awk '$3 != "Running" && $3 != "Completed" {print $1}'); do
      echo "--- $p ---"
      $KUBECTL describe pod "$p" -n "$NS_ARG" | tail -25
    done
    echo ""
    echo "=== events (last 20) ==="
    $KUBECTL get events -n "$NS_ARG" --sort-by=.lastTimestamp | tail -20
    ;;
  describe)
    RES="${ARGS[0]:?usage: describe <resource> <name>}"
    NAME="${ARGS[1]:?usage: describe <resource> <name>}"
    $KUBECTL describe "$RES" "$NAME" -n "$NS"
    ;;
esac