# PowerShell Script to Install and Configure Docker and Jenkins

# Update package list and upgrade packages
Write-Output "Updating package list and upgrading packages..."
Invoke-Expression 'sudo apt-get update && sudo apt-get upgrade -y'

# Install OpenJDK 8
Write-Output "Installing OpenJDK 8..."
Invoke-Expression 'sudo apt-get install openjdk-8-jre-headless -y'

# Add Jenkins repository and key
Write-Output "Adding Jenkins repository and key..."
Invoke-WebRequest -Uri "https://pkg.jenkins.io/debian/jenkins-ci.org.key" -OutFile "jenkins-ci.org.key"
Invoke-Expression 'sudo apt-key add jenkins-ci.org.key'
Invoke-Expression 'sudo sh -c ''echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'''

# Update package list again and install Jenkins
Write-Output "Updating package list and installing Jenkins..."
Invoke-Expression 'sudo apt-get update && sudo apt-get install jenkins -y'

# Install Docker
Write-Output "Installing Docker..."
Invoke-WebRequest -Uri "https://get.docker.com/" -OutFile "get-docker.sh"
Invoke-Expression 'sudo sh get-docker.sh'

# Configure Docker to listen on TCP
Write-Output "Configuring Docker to listen on TCP..."
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
Write-Output "Adding users to Docker group..."
Invoke-Expression 'sudo usermod -aG docker azureuser'
Invoke-Expression 'sudo usermod -aG docker jenkins'

# Restart Jenkins service
Write-Output "Restarting Jenkins service..."
Invoke-Expression 'sudo service jenkins restart'

Write-Output "Configuration complete."
