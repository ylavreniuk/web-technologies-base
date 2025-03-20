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

# Check if WinGet is installed
if (!(Command-Exists winget)) {
    Write-Host "WinGet is not installed. Please install it manually: https://aka.ms/getwinget"
    exit 1
}

# Uninstall required tools using WinGet
$packages = @(
    @{ Name = "Git.Git"; Command = "git" },
    @{ Name = "Python.Python.3.12"; Command = "python" },
    @{ Name = "SQLite.SQLite"; Command = "sqlite3" },
    @{ Name = "astral-sh.uv"; Command = "uv" }
)

foreach ($package in $packages) {
    if (Command-Exists $package.Command) {
        Write-Host "Uninstalling $($package.Command) using WinGet..."
        winget uninstall --id=$($package.Name) -e --silent --accept-source-agreements --accept-package-agreements

        if (!(Command-Exists $package.Command)) {
            Write-Host "$($package.Command) uninstalled successfully."
        } else {
            Write-Host "$($package.Command) uninstallation failed. Please check manually."
            exit 1
        }
    } else {
        Write-Host "$($package.Command) is not installed. Skipping."
    }
}

# Remove dependencies installed by uv
Write-Host "Removing Python dependencies installed by uv..."
if (Test-Path "$BaseInstallPath\venv") {
    Remove-Item -Recurse -Force "$BaseInstallPath\venv"
    Write-Host "Virtual environment removed."
}

# Remove tools directory
Write-Host "Removing tools directory..."
if (Test-Path $BaseInstallPath) {
    Remove-Item -Recurse -Force $BaseInstallPath
    Write-Host "Tools directory removed successfully."
} else {
    Write-Host "Tools directory does not exist."
}

Write-Host "Uninstallation complete. Restart your terminal to apply changes."
