# Set installation paths on Windows
$BaseInstallPath = "$env:LOCALAPPDATA\tools"
$PythonPath = "$BaseInstallPath\Python"
$SQLitePath = "$BaseInstallPath\SQLite"
$UvPath = "$BaseInstallPath\Uv"

# Function to check if a command exists
function Command-Exists {
    param ($command)
    return [bool](Get-Command $command -ErrorAction SilentlyContinue)
}

# Ensure the base install directory exists
if (!(Test-Path $BaseInstallPath)) {
    New-Item -ItemType Directory -Path $BaseInstallPath -Force | Out-Null
}

# Check if WinGet is installed
if (!(Command-Exists winget)) {
    Write-Host "WinGet is not installed. Please install it manually: https://github.com/microsoft/winget-cli?tab=readme-ov-file#microsoft-store-recommended"
    exit 1
}

# Install required tools using WinGet
$packages = @(
    @{ Name = "Git.Git"; Command = "git" },
    @{ Name = "Python.Python.3.12"; Command = "python" },
    @{ Name = "SQLite.SQLite"; Command = "sqlite3" },
    @{ Name = "astral-sh.uv"; Command = "uv" }
)

foreach ($package in $packages) {
    Write-Host "Installing $($package.Command) using WinGet..."
    winget install --id=$($package.Name) -e --silent --accept-source-agreements --accept-package-agreements
    Write-Host "$($package.Command) installation complete. If you cannot access the command, restart your terminal or open a new one."
}

# Install dependencies using uv
Write-Host "Installing Python dependencies from pyproject.toml..."
if (Test-Path "pyproject.toml") {
    Write-Host "Found pyproject.toml. Installing dependencies..."
    uv pip install -r requirements.txt
    Write-Host "Dependencies installed successfully."
} else {
    Write-Host "Error: No pyproject.toml found in the current directory. Skipping dependency installation."
}

Write-Host "Installation complete. If you cannot access the installed commands, restart your terminal or open a new one."