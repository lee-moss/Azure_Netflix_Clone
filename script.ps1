# PowerShell Script to Install and Configure Docker and Jenkins

# Update package list and upgrade packages
Write-Host "Updating package list and upgrading packages..."
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "apt-get", "update"
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "apt-get", "upgrade", "-y"

# Install OpenJDK 8
Write-Host "Installing OpenJDK 8..."
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "apt-get", "install", "openjdk-8-jre-headless", "-y"

# Add Jenkins repository and key
Write-Host "Adding Jenkins repository and key..."
Invoke-WebRequest -Uri "https://pkg.jenkins.io/debian/jenkins.io.key" -OutFile "jenkins.io.key"
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "apt-key", "add", "jenkins.io.key"
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "sh", "-c", "echo 'deb http://pkg.jenkins.io/debian-stable binary/' | tee /etc/apt/sources.list.d/jenkins.list"

# Update package list again and install Jenkins
Write-Host "Updating package list and installing Jenkins..."
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "apt-get", "update"
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "apt-get", "install", "jenkins", "-y"

# Install Docker
Write-Host "Installing Docker..."
Invoke-WebRequest -Uri "https://get.docker.com/" -OutFile "get-docker.sh"
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "sh", "get-docker.sh"

# Configure Docker to listen on TCP
Write-Host "Configuring Docker to listen on TCP..."
$dockerServiceConfig = @"
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://127.0.0.1:2375
"@
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "bash", "-c", "mkdir -p /etc/systemd/system/docker.service.d"
$dockerServiceConfig | Out-File -FilePath "/etc/systemd/system/docker.service.d/docker.conf" -Encoding utf8
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "systemctl", "daemon-reload"
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "systemctl", "restart", "docker"

# Restart Jenkins service
Write-Host "Restarting Jenkins service..."
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "systemctl", "restart", "jenkins"

# Clean up temporary files
Remove-Item -Path "jenkins.io.key", "get-docker.sh" -Force

Write-Host "Configuration complete."