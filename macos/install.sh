#!/bin/bash
set -e

echo "> Installing Bowl Browser..."

# Build first if needed
if [ ! -d "build/Bowl.app" ]; then
    echo "Building Bowl..."
    ./build.sh
fi

# Install app
echo ">> Installing Bowl.app to /Applications..."
sudo rm -rf /Applications/Bowl.app
sudo cp -r build/Bowl.app /Applications/

# Fix permissions and ownership
sudo chown -R root:admin /Applications/Bowl.app
sudo chmod -R 755 /Applications/Bowl.app

# Remove extended attributes
sudo xattr -cr /Applications/Bowl.app

# Code sign with ad-hoc signature
echo ">>> Code signing Bowl.app..."
sudo codesign --force --deep --sign - /Applications/Bowl.app

# Verify the signature
codesign -vvv /Applications/Bowl.app 2>&1 | grep -i "valid" || echo "Warning: Signature verification failed"

# Install CLI
echo ">>>> Installing bowl CLI to /usr/local/bin..."
sudo cp .build/release/bowl-cli /usr/local/bin/bowl
sudo chmod +x /usr/local/bin/bowl

# Setup config directory
echo ">>>>> Setting up Bowl config directory..."
mkdir -p ~/.bowl/plugins

# Copy example config if doesn't exist
if [ ! -f ~/.bowl/config.toml ]; then
    if [ -f ../examples/configs/config.toml ]; then
        cp ../examples/configs/config.toml ~/.bowl/
        echo "(!) Created default config at ~/.bowl/config.toml"
    else
        echo "(!) Note: Config will be auto-generated on first launch"
    fi
fi

# Copy example plugins
echo ">>>>>> Installing example plugins..."
cp -r ../examples/plugins/* ~/.bowl/plugins/ 2>/dev/null || true

echo ""
echo "Bowl installed successfully!"
echo ""
echo "Usage:"
echo "  bowl          # Launch browser"
echo "  bowl <url>    # Open URL"
echo ""
echo "-> Config: ~/.bowl/config.toml"
echo "-> Plugins: ~/.bowl/plugins/"
echo ""
echo "Press Cmd+B in Bowl to open the overlay"
