#!/bin/bash

# Update package lists
sudo apt-get update

# Install OpenJDK 17
sudo apt-get install -y openjdk-17-jdk

# Verify Java installation
java -version

# Set JAVA_HOME environment variable
echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> ~/.bashrc
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> ~/.bashrc

# Reload .bashrc to apply changes
source ~/.bashrc

# Print Java home directory
echo "Java home directory: $JAVA_HOME"

# Print success message
echo "OpenJDK 17 has been successfully installed!"
