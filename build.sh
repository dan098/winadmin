#!/bin/bash

# Funzione per controllare e installare le dipendenze
check_and_install_dependencies() {
    local deps=("wget" "xorriso" "squashfs-tools" "syslinux")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "Installazione di $dep..."
            sudo apt-get update && sudo apt-get install -y "$dep"
        fi
    done
}

# Scarica l'immagine ISO di Alpine Linux più leggera
download_alpine_iso() {
    local alpine_url="https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86_64/alpine-minirootfs-3.18.0-x86_64.tar.gz"
    wget "$alpine_url" -O alpine-minirootfs.tar.gz
}

# Crea una nuova immagine ISO con lo script incorporato
create_custom_iso() {
    # Estrai il contenuto dell'immagine Alpine
    mkdir -p alpine-root/apks/x86_64
    tar -xzf alpine-minirootfs.tar.gz -C alpine-root

    # Copia lo script nella directory root
    cp admin.sh alpine-root/
    cp apks/x86_64/ntfs-3g-2022.10.3-r3.apk alpine-root/apks/x86_64
    cp apks/x86_64/ntfs-3g-libs-2022.10.3-r3.apk alpine-root/apks/x86_64

    # Crea la struttura per il boot
    mkdir -p alpine-root/boot/syslinux
    cp /usr/lib/syslinux/modules/bios/*.c32 alpine-root/boot/syslinux/
    cp /usr/lib/ISOLINUX/isolinux.bin alpine-root/boot/syslinux/
    
    # Crea il file di configurazione per SYSLINUX
    cat > alpine-root/boot/syslinux/syslinux.cfg << EOF
DEFAULT alpine
LABEL alpine
    LINUX /boot/vmlinuz-virt
    INITRD /boot/initramfs-virt
    APPEND root=/dev/sda3 modules=loop,squashfs console=tty0
EOF

    # Crea l'immagine ISO
    xorriso -as mkisofs \
        -o custom-alpine.iso \
        -b boot/syslinux/isolinux.bin \
        -c boot/syslinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -eltorito-alt-boot \
        -e boot/syslinux/efiboot.img \
        -no-emul-boot \
        -isohybrid-gpt-basdat \
        -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
        alpine-root

    # Pulisci i file temporanei
    rm -rf alpine-root alpine-minirootfs.tar.gz
}

# Script principale
main() {
    check_and_install_dependencies
    download_alpine_iso
    create_custom_iso
    echo "ISO personalizzata creata: custom-alpine.iso"
    echo "Puoi ora montare questa ISO su una chiavetta USB usando un tool come 'dd' o 'Etcher'."
}

# Esegui lo script
main