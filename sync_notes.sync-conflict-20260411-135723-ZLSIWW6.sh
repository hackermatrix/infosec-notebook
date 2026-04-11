#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# sync_notes.sh — Auto-commit and push note changes to GitHub
#
# SETUP:
#   1. Set NOTES_DIR to the path of this repo on your server
#   2. Make executable:  chmod +x sync_notes.sh
#   3. Add to cron:      crontab -e
#      Run daily at 2 AM:  0 2 * * * /path/to/sync_notes.sh
#
# REQUIREMENTS:
#   - Git must be installed on the server
#   - SSH key for GitHub must be configured (ssh-keygen + add to GitHub)
#     OR a Personal Access Token stored in the git credential helper
# ─────────────────────────────────────────────────────────────────────────────

# ── Config ────────────────────────────────────────────────────────────────────
NOTES_DIR="/path/to/your/notes"          # <── CHANGE THIS to the actual path on your server
BRANCH="master"
LOG_FILE="/var/log/notes_sync.log"       # Change or set to "" to disable logging
MAX_LOG_LINES=500                        # Keeps the log from growing forever

# ── Helpers ───────────────────────────────────────────────────────────────────
log() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "$msg"
    [[ -n "$LOG_FILE" ]] && echo "$msg" >> "$LOG_FILE"
}

# ── Pre-flight ────────────────────────────────────────────────────────────────
if [[ ! -d "$NOTES_DIR/.git" ]]; then
    log "ERROR: $NOTES_DIR is not a git repository. Aborting."
    exit 1
fi

cd "$NOTES_DIR" || { log "ERROR: Cannot cd into $NOTES_DIR"; exit 1; }

# ── Check for changes ─────────────────────────────────────────────────────────
if ! git status --porcelain | grep -q .; then
    log "No changes detected. Nothing to push."
    exit 0
fi

log "Changes detected. Starting sync..."

# ── Pull first to avoid push conflicts ───────────────────────────────────────
log "Stashing local changes before pull..."
git stash --include-untracked 2>&1 | while read -r line; do log "  $line"; done

log "Pulling latest from origin/$BRANCH..."
git pull --rebase origin "$BRANCH" 2>&1 | while read -r line; do log "  $line"; done

PULL_EXIT=${PIPESTATUS[0]}
if [[ $PULL_EXIT -ne 0 ]]; then
    log "ERROR: git pull failed (exit $PULL_EXIT). Aborting to avoid overwriting remote changes."
    git stash pop 2>&1 | while read -r line; do log "  $line"; done
    exit 1
fi

log "Restoring stashed changes..."
git stash pop 2>&1 | while read -r line; do log "  $line"; done

# ── Stage, commit, push ───────────────────────────────────────────────────────
git add -A

COMMIT_MSG="auto-sync: $(date '+%Y-%m-%d %H:%M')"
git commit -m "$COMMIT_MSG" 2>&1 | while read -r line; do log "  $line"; done

log "Pushing to origin/$BRANCH..."
git push origin "$BRANCH" 2>&1 | while read -r line; do log "  $line"; done

PUSH_EXIT=${PIPESTATUS[0]}
if [[ $PUSH_EXIT -ne 0 ]]; then
    log "ERROR: git push failed (exit $PUSH_EXIT). Check your SSH key or token."
    exit 1
fi

log "Sync complete."

# ── Trim log file ─────────────────────────────────────────────────────────────
if [[ -n "$LOG_FILE" && -f "$LOG_FILE" ]]; then
    tail -n "$MAX_LOG_LINES" "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
fi

exit 0
