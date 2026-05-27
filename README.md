# Pray

A simple CLI tool that displays random Bible quotes to inspire and encourage you.

## Features

- 📖 **60 Bible quotes** from both Old and New Testament
- 🎲 **Random selection** - get a different quote each time
- ⚡ **Fast and lightweight** - written in Go
- 📝 **Beautifully formatted** - with verse references

## Installation

### Quick Install (Unix/Linux/macOS)

Use the provided installation script:
```bash
./install.sh                    # Install to current directory
./install.sh --global           # Install to /usr/local/bin (sudo required)
./install.sh -d ~/bin           # Install to custom directory
```

### Quick Install (Windows)

Use the provided batch installer:
```cmd
install.bat                     # Install to current directory
install.bat --global            # Install to Program Files (admin required)
install.bat -d C:\Tools         # Install to custom directory
```

## Premium Tier

A premium version is available with 600 Bible quotes instead of 60.

### Activating Premium

More details to come


## Uninstallation

### Unix/Linux/macOS

```bash
./uninstall.sh                  # Uninstall from current directory
./uninstall.sh --global         # Uninstall from /usr/local/bin (sudo required)
./uninstall.sh -d ~/bin         # Uninstall from custom directory
```

### Windows

```cmd
uninstall.bat                   # Uninstall from current directory
uninstall.bat --global          # Uninstall from Program Files (admin required)
uninstall.bat -d C:\Tools       # Uninstall from custom directory
```

## Cross-Platform Builds

To build executables for multiple platforms (Windows, macOS, Linux) and architectures (x86, ARM, etc.), use the provided build script:

```bash
# Build for all platforms
./build.sh all

# Build for a specific platform
./build.sh linux-amd64
./build.sh macos-arm64
./build.sh windows-amd64

# Build for your current OS
./build.sh current

# Clean build artifacts
./build.sh clean
```

**Supported targets:**
- `windows-amd64` - Windows 64-bit
- `windows-386` - Windows 32-bit
- `windows-arm64` - Windows ARM64
- `macos-amd64` - macOS Intel (10.12+)
- `macos-arm64` - macOS Apple Silicon (M1+)
- `linux-amd64` - Linux 64-bit
- `linux-386` - Linux 32-bit
- `linux-arm` - Linux ARM (32-bit)
- `linux-arm64` - Linux ARM64

Binaries are organized in the `build/` directory. The quotes are fetched dynamically from the CDN, so no bundled data files are needed.

## Automated Releases

This project uses **GitHub Actions** to automatically build and release executables for all platforms whenever a new version tag is pushed.

### Creating a Release

1. **Create a tag** with semantic versioning:
```bash
git tag v1.0.0
git push origin v1.0.0
```

2. **GitHub Actions automatically:**
   - Builds for all 9 platform/architecture combinations
   - Creates platform-specific archives (`.zip` for Windows, `.tar.gz` for Unix)
   - Publishes a GitHub Release with all binaries

3. **Users can download** pre-built executables from the [Releases](https://github.com/krisraven/pray-releases/releases) page

### Release Process

- **Trigger:** Push a git tag starting with `v` (e.g., `v1.0.0`, `v1.1.0`)
- **Build Time:** ~5-10 minutes total
- **Outputs:** Pre-compiled binaries ready for distribution

For detailed information, see [.github/workflows/README.md](.github/workflows/README.md).

## Usage

Simply type the command:
```bash
pray
```

Each time you run it, you'll see a random Bible quote with its reference:

```
For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.
— John 3:16
```

## Adding More Quotes

You can add more quotes to the `quotes.json` file. Each quote should follow this format:

```json
{
  "text": "Quote text here",
  "reference": "Book Chapter:Verse"
}
```

**No rebuild needed!** The quotes are fetched from the CDN, so users automatically get the updated quotes when they run the tool. Just commit and push your changes to the repository:

```bash
git add quotes.json
git commit -m "Add new quotes"
git push origin main
```

The CLI will fetch the latest quotes from jsDelivr CDN on the next run.

## Testing

Run the test suite:
```bash
go test -v
```

Tests verify:
- JSON parsing functionality
- Quote data structure integrity
- Proper unmarshaling of quote data

## Distribution & Packaging

For comprehensive information on distributing and selling the Pray CLI tool, see [DISTRIBUTION.md](DISTRIBUTION.md).

**Key distribution features:**
- Automated multi-platform builds via GitHub Actions
- Universal installation scripts for Unix and Windows
- Pre-built binaries for all platforms
- Support for Gumroad, Itch.io, package managers, and more
- Pricing models and licensing strategies

## Project Structure

```
pray/
├── main.go                          # Main program logic
├── main_test.go                     # Unit tests
├── quotes.json                      # Bible quotes database
├── go.mod                           # Go module definition
├── build.sh                         # Cross-platform build script
├── Makefile                         # Alternative build automation
├── quotes-premium.json              # Premium quotes database (not distributed publicly)
├── install.sh                       # Universal Unix installer
├── install.bat                      # Windows batch installer
├── uninstall.sh                     # Universal Unix uninstaller
├── uninstall.bat                    # Windows batch uninstaller
├── .gitignore                       # Git ignore rules
├── LICENSE                          # Commercial software license
├── COMMERCIAL_LICENSE.md            # Licensing strategy guide
├── DISTRIBUTION.md                  # Distribution & packaging guide
├── README.md                        # This file
└── .github/
    └── workflows/
        ├── build-release.yml        # GitHub Actions workflow
        └── README.md                # Workflow documentation
```

## Quote Sources

All Bible quotes are taken from standard Bible translations and contain 60 inspirational verses from both the Old and New Testaments.

## License

This software is provided under a **Commercial Software License Agreement**.

**Personal Use:** You may use this software for personal, non-commercial purposes.

**Commercial Use:** For commercial distribution, resale, or bundling, a commercial license is required.

See the [LICENSE](LICENSE) file for complete terms and conditions.

For commercial licensing inquiries, please contact the publisher.

## Contributing

Pull requests are welcome! Feel free to add more quotes or improve the tool.
