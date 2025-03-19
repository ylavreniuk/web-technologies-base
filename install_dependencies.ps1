# Set installation paths on D:\ drive
$BaseInstallPath = "D:\Tools"
$PythonPath = "$BaseInstallPath\Python"
$SQLitePath = "$BaseInstallPath\SQLite"
$PoetryPath = "$BaseInstallPath\Poetry"

# Function to check if a command exists
function Command-Exists {
    param ($command)
    return [bool](Get-Command $command -ErrorAction SilentlyContinue)
}

# Ensure the base install directory exists
if (!(Test-Path $BaseInstallPath)) {
    New-Item -ItemType Directory -Path $BaseInstallPath | Out-Null
}

# Install Python
if (!(Command-Exists python)) {
    Write-Host "Python not found. Installing Python to $PythonPath..."
    
    $PythonInstallerUrl = "https://www.python.org/ftp/python/3.12.1/python-3.12.1-amd64.exe"
    $PythonInstallerPath = "$env:TEMP\python-installer.exe"
    
    Invoke-WebRequest -Uri $PythonInstallerUrl -OutFile $PythonInstallerPath
    
    Write-Host "Running Python installer..."
    Start-Process -FilePath $PythonInstallerPath -ArgumentList "/quiet InstallAllUsers=1 TargetDir=$PythonPath PrependPath=1" -Wait
    
    # Verify Python installation
    if (Test-Path "$PythonPath\python.exe") {
        Write-Host "Python installed successfully in $PythonPath."
    } else {
        Write-Host "Python installation failed. Please check manually."
        exit 1
    }
} else {
    Write-Host "Python is already installed."
}

# Install SQLite
if (!(Test-Path $SQLitePath)) {
    New-Item -ItemType Directory -Path $SQLitePath | Out-Null
}

$SQLiteUrl = "https://www.sqlite.org/2024/sqlite-tools-win32-x86-3440200.zip"
$DownloadPath = "$env:TEMP\sqlite.zip"

Write-Host "Downloading SQLite..."
Invoke-WebRequest -Uri $SQLiteUrl -OutFile $DownloadPath

Write-Host "Extracting SQLite to $SQLitePath..."
Expand-Archive -Path $DownloadPath -DestinationPath $SQLitePath -Force

$envPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
if ($envPath -notlike "*$SQLitePath*") {
    Write-Host "Adding SQLite to system PATH..."
    [System.Environment]::SetEnvironmentVariable("Path", "$envPath;$SQLitePath", [System.EnvironmentVariableTarget]::Machine)
}

Write-Host "SQLite installed successfully in $SQLitePath."

# Install Poetry
if (!(Command-Exists poetry)) {
    Write-Host "Installing Poetry to $PoetryPath..."
    Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing | Invoke-Expression

    # Verify Poetry installation
    if (Command-Exists poetry) {
        Write-Host "Poetry installed successfully."
    } else {
        Write-Host "Poetry installation failed. Try running the script as Administrator."
        exit 1
    }
} else {
    Write-Host "Poetry is already installed."
}

# Install dependencies using Poetry
Write-Host "Installing Python dependencies from pyproject.toml..."
if (Test-Path "pyproject.toml") {
    Write-Host "Found pyproject.toml. Installing dependencies..."
    poetry install
    Write-Host "Dependencies installed successfully."
} else {
    Write-Host "Error: No pyproject.toml found in the current directory. Skipping dependency installation."
}

Write-Host "Installation complete. Restart your terminal to apply changes."

