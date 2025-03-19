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

# Uninstall Poetry
if (Command-Exists poetry) {
    Write-Host "Uninstalling Poetry..."
    poetry self uninstall -y
} else {
    Write-Host "Poetry is not installed."
}

# Uninstall Python
if (Test-Path "$PythonPath\python.exe") {
    Write-Host "Uninstalling Python from $PythonPath..."
    Remove-Item -Recurse -Force $PythonPath
    Write-Host "Python uninstalled successfully."
} else {
    Write-Host "Python is not installed in $PythonPath."
}

# Uninstall SQLite
if (Test-Path $SQLitePath) {
    Write-Host "Uninstalling SQLite from $SQLitePath..."
    Remove-Item -Recurse -Force $SQLitePath
    Write-Host "SQLite uninstalled successfully."
} else {
    Write-Host "SQLite is not installed in $SQLitePath."
}

# Remove Poetry path (if exists)
if (Test-Path $PoetryPath) {
    Write-Host "Removing Poetry directory..."
    Remove-Item -Recurse -Force $PoetryPath
}

# Remove paths from the system PATH variable
$envPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
$NewPath = $envPath -replace [regex]::Escape("$PythonPath;"), "" -replace [regex]::Escape("$SQLitePath;"), "" -replace [regex]::Escape("$PoetryPath;"), ""

[System.Environment]::SetEnvironmentVariable("Path", $NewPath, [System.EnvironmentVariableTarget]::Machine)

Write-Host "Cleanup complete. Restart your system to apply changes."

