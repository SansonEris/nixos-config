#!/usr/bin/env bash

# Script per sincronizzare le configurazioni NixOS e Home Manager con GitHub
# Uso: ./sync-nixos-config.sh [messaggio-commit]

set -e

# Colori per output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Directory
REPO_DIR="$HOME/nixos-config"
NIXOS_SOURCE="/etc/nixos"
HOME_MANAGER_SOURCE="$HOME/.config/home-manager"

echo -e "${BLUE}Sincronizzazione configurazioni NixOS...${NC}"

# Vai nella directory del repo
cd "$REPO_DIR"

# Rimuovi i vecchi symlink/directory se esistono
rm -rf nixos home-manager

# Copia le directory
echo -e "${BLUE}Copiando /etc/nixos...${NC}"
cp -r "$NIXOS_SOURCE" ./nixos

echo -e "${BLUE}Copiando ~/.config/home-manager...${NC}"
cp -r "$HOME_MANAGER_SOURCE" ./home-manager

# Rimuovi il .git dalle directory copiate (se esiste)
rm -rf ./nixos/.git ./home-manager/.git

# Aggiungi i file a git
echo -e "${BLUE}Aggiungendo file a git...${NC}"
git add .

# Controlla se ci sono modifiche
if git diff --staged --quiet; then
    echo -e "${GREEN}Nessuna modifica da committare${NC}"
    exit 0
fi

# Messaggio di commit
if [ -z "$1" ]; then
    COMMIT_MSG="Update NixOS configuration - $(date '+%Y-%m-%d %H:%M:%S')"
else
    COMMIT_MSG="$1"
fi

# Commit
echo -e "${BLUE}Creando commit...${NC}"
git commit -m "$COMMIT_MSG"

# Push
echo -e "${BLUE}Push su GitHub...${NC}"
git push

echo -e "${GREEN}Sincronizzazione completata${NC}"
