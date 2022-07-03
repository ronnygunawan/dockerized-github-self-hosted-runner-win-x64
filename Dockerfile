FROM mcr.microsoft.com/windows/servercore:ltsc2022 AS runner

# Declare arguments
ARG URL
ARG TOKEN

# Create a folder under the drive root
WORKDIR /
RUN mkdir actions-runner

# Switch shell to powershell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Download the latest runner package
WORKDIR /actions-runner
RUN Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.294.0/actions-runner-win-x64-2.294.0.zip -OutFile actions-runner-win-x64-2.294.0.zip

# Validate the hash
RUN if((Get-FileHash -Path actions-runner-win-x64-2.294.0.zip -Algorithm SHA256).Hash.ToUpper() -ne '22295b3078f7303ffb5ded4894188d85747b1b1a3d88a3eac4d0d076a2f62caa'.ToUpper()){ throw 'Computed checksum did not match' }

# Extract the installer
RUN Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory('/actions-runner/actions-runner-win-x64-2.294.0.zip', '/actions-runner')

# Switch shell to CMD
SHELL ["cmd", "/S", "/C"]

# Create the runner and start the configuration experience
RUN config.cmd --url %URL% --token %TOKEN%

# Run it!
ENTRYPOINT ["run.cmd"]