#!/usr/bin/env bash
# Check whether the Effect API reference is present and fresh.
# Outputs exactly one line: OK | MISSING | STALE: ... | ERROR: ...

MAX_AGE_DAYS=90
EFFECT_DIR=".vendor/effect"

if [ ! -d "$EFFECT_DIR" ]; then
  echo "MISSING"
elif LAST_COMMIT=$(git -C .vendor/effect log -1 --format=%ct 2>/dev/null); then
  CUTOFF=$(date -v-${MAX_AGE_DAYS}d +%s 2>/dev/null || date -d "${MAX_AGE_DAYS} days ago" +%s)
  if [ "$LAST_COMMIT" -lt "$CUTOFF" ]; then
    # Age-based check failed — verify against remote before calling it stale
    if git -C .vendor/effect fetch --depth 1 origin main 2>/dev/null; then
      LOCAL=$(git -C .vendor/effect rev-parse HEAD)
      REMOTE=$(git -C .vendor/effect rev-parse FETCH_HEAD)
      if [ "$LOCAL" = "$REMOTE" ]; then
        echo "OK"
      else
        AGE_DAYS=$(( ($(date +%s) - LAST_COMMIT) / 86400 ))
        echo "STALE: Effect API reference is ${AGE_DAYS} days old"
      fi
    else
      AGE_DAYS=$(( ($(date +%s) - LAST_COMMIT) / 86400 ))
      echo "STALE: Effect API reference is ${AGE_DAYS} days old (could not verify remote)"
    fi
  else
    echo "OK"
  fi
else
  echo "ERROR: .vendor/effect exists but is not a valid git repo"
fi
