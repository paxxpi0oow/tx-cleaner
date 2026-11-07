#!/data/data/com.termux/files/usr/bin/bash

# Warna
C_RED='\033[0;31m'; C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'; C_BLUE='\033[0;34m'; C_RESET='\033[0m'

scan_cache() {
    echo -e "${C_BLUE}=== Memindai Cache Paket ===${C_RESET}"
    local apt_cache=$(du -sh $PREFIX/var/cache/apt 2>/dev/null | cut -f1)
    local pip_cache=$(du -sh ~/.cache/pip 2>/dev/null | cut -f1)
    local npm_cache=$(du -sh ~/.npm/_cacache 2>/dev/null | cut -f1)
    local gem_cache=$(du -sh ~/.gem 2>/dev/null | cut -f1)
    local cargo_cache=$(du -sh ~/.cargo/registry 2>/dev/null | cut -f1)

    echo -e "  Apt    : ${C_YELLOW}${apt_cache:-0B}${C_RESET}"
    echo -e "  Pip    : ${C_YELLOW}${pip_cache:-0B}${C_RESET}"
    echo -e "  Npm    : ${C_YELLOW}${npm_cache:-0B}${C_RESET}"
    echo -e "  Gem    : ${C_YELLOW}${gem_cache:-0B}${C_RESET}"
    echo -e "  Cargo  : ${C_YELLOW}${cargo_cache:-0B}${C_RESET}"
    echo ""
}

scan_home() {
    echo -e "${C_BLUE}=== 5 Folder Terbesar di Home (~) ===${C_RESET}"
    du -h -d 1 ~ 2>/dev/null | sort -rh | head -n 6 | tail -n 5 | awk '{print "  " $1 "\t" $2}'
    echo ""
}

clean_cache() {
    echo -e "${C_YELLOW}[!] PERINGATAN: Ini akan menghapus cache paket.${C_RESET}"
    echo -e "    Paket yang sudah terinstal TIDAK akan terhapus."
    read -p "    Lanjutkan? (y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo -e "${C_RED}[x] Dibatalkan.${C_RESET}"
        return
    fi
    
    echo -e "${C_GREEN}[*] Membersihkan cache...${C_RESET}"
    apt clean 2>/dev/null
    rm -rf ~/.cache/pip 2>/dev/null
    npm cache clean --force 2>/dev/null
    rm -rf ~/.gem 2>/dev/null
    rm -rf ~/.cargo/registry 2>/dev/null
    
    echo -e "${C_GREEN}[+] Selesai! Storage kamu sudah lega.${C_RESET}"
    scan_cache
}

case "${1:-}" in
    scan)  scan_cache; scan_home ;;
    clean) clean_cache ;;
    *)
        echo -e "${C_BLUE}tx-cleaner - Termux Storage Cleaner${C_RESET}"
        echo "Usage:"
        echo "  tx-cleaner scan    # Cek ukuran cache dan folder terbesar"
        echo "  tx-cleaner clean   # Hapus cache yang tidak terpakai"
        ;;
esac
