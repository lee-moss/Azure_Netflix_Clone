# PowerShell Script to Install and Configure Docker and Jenkins

# Update package list and upgrade packages
Write-Host "Updating package list and upgrading packages..."
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "apt-get update && sudo apt-get upgrade -y"

# Install OpenJDK 8
Write-Host "Installing OpenJDK 8..."
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "apt-get install openjdk-8-jre-headless -y"

# Add Jenkins repository and key
Write-Host "Adding Jenkins repository and key..."
Invoke-WebRequest -Uri "https://pkg.jenkins.io/debian/jenkins-ci.org.key" -OutFile "jenkins-ci.org.key"
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "apt-key add jenkins-ci.org.key"
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'"

# Update package list again and install Jenkins
Write-Host "Updating package list and installing Jenkins..."
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "apt-get update && sudo apt-get install jenkins -y"

# Install Docker
Write-Host "Installing Docker..."
Invoke-WebRequest -Uri "https://get.docker.com/" -OutFile "get-docker.sh"
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "sh get-docker.sh"

# Configure Docker to listen on TCP
Write-Host "Configuring Docker to listen on TCP..."
$dockerServiceConfig = @"
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
"@
$dockerDaemonConfig = @"
{
  "hosts": ["fd://","tcp://127.0.0.1:2375"]
}
"@
New-Item -Path /etc/systemd/system/docker.service.d -ItemType Directory -Force
Set-Content -Path /etc/systemd/system/docker.service.d/docker.conf -Value $dockerServiceConfig
Set-Content -Path /etc/docker/daemon.json -Value $dockerDaemonConfig

# Add 'azureuser' and 'jenkins' to the 'docker' group
Write-Host "Adding users to Docker group..."
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "usermod -aG docker azureuser"
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "usermod -aG docker jenkins"

# Restart Jenkins service
Write-Host "Restarting Jenkins service..."
Start-Process -NoNewWindow -Wait -FilePath "sudo" -ArgumentList "service jenkins restart"

# Clean up temporary files
Remove-Item -Path "jenkins-ci.org.key", "get-docker.sh" -Force

Write-Host "Configuration complete."