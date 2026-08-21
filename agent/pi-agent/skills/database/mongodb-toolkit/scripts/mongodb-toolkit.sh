#!/usr/bin/env bash
# MongoDB Toolkit — inspect collections, indexes, run aggregation, explain
# Source: https://www.mongodb.com/docs/manual/reference/command/
set -euo pipefail

SCRIPT_NAME="mongodb-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} collections [uri]                 # URI default mongodb://localhost:27017
       ${SCRIPT_NAME} indexes <db.collection> [uri]
       ${SCRIPT_NAME} count <db.collection> [uri]
       ${SCRIPT_NAME} aggregate <db.collection> <pipeline.json> [uri]
       ${SCRIPT_NAME} explain <db> <collection> <query.json> [uri]
Inspect MongoDB collections, indexes, counts; run aggregation pipelines.
Requires the mongosh client.

Options:
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
URI="mongodb://localhost:27017"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    collections|indexes|count|aggregate|explain) CMD="$1"; shift;;
    *) if [[ "$1" == mongodb://* || "$1" == mongodb+srv://* ]]; then URI="$1"; else ARGS+=("$1"); fi; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
: "${MONGO:?mongosh not found — install mongodb-mongosh or set MONGO=path}"

case "$CMD" in
  collections)
    $MONGO "$URI" --quiet --eval "db.getSiblingDB('admin').adminCommand({listDatabases:1}).databases.forEach(d => print(d.name))"
    ;;
  indexes)
    NS="${ARGS[0]:?usage: indexes <db.collection>}"
    DB="${NS%%.*}" COLL="${NS#*.}"
    $MONGO "$URI" --quiet --eval "db.getSiblingDB('$DB').getCollection('$COLL').getIndexes().forEach(i => printjson(i))"
    ;;
  count)
    NS="${ARGS[0]:?usage: count <db.collection>}"
    DB="${NS%%.*}" COLL="${NS#*.}"
    $MONGO "$URI" --quiet --eval "print(db.getSiblingDB('$DB').getCollection('$COLL').countDocuments({}))"
    ;;
  aggregate)
    NS="${ARGS[0]:?usage: aggregate <db.collection> <pipeline.json>}"
    PIPELINE="${ARGS[1]:?missing pipeline.json}"
    DB="${NS%%.*}" COLL="${NS#*.}"
    [ -f "$PIPELINE" ] || { echo "pipeline file not found: $PIPELINE" >&2; exit 1; }
    P=$(cat "$PIPELINE")
    $MONGO "$URI" --quiet --eval "db.getSiblingDB('$DB').getCollection('$COLL').aggregate($P).forEach(d => printjson(d))"
    ;;
  explain)
    NS="${ARGS[0]:?usage: explain <db> <collection> <query.json>"}
    QFILE="${ARGS[1]:?missing query.json}"
    DB="${NS%%.*}" COLL="${NS#*.}"
    [ -f "$QFILE" ] || { echo "query file not found: $QFILE" >&2; exit 1; }
    Q=$(cat "$QFILE")
    $MONGO "$URI" --quiet --eval "printjson(db.getSiblingDB('$DB').getCollection('$COLL').find($Q).explain('executionStats'))"
    ;;
esac