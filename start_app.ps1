# Check if uv is installed
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "uv is not installed. Please install it first using 'pip install uv' or follow official docs."
    exit 1
}

# Create virtual environment using uv
Write-Host "Creating virtual environment using uv..."
uv venv

# Activate virtual environment
Write-Host "Activating virtual environment..."
.\.venv\Scripts\activate

# Install dependencies from pyproject.toml
Write-Host "Installing dependencies from pyproject.toml..."
uv sync

# Run FastAPI app
Write-Host "Starting FastAPI app with uvicorn..."
fastapi dev src/main.py