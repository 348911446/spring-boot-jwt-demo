
Simple demo with only 3 classes  

#### Please run example in *basic* folder;  
#### Then try to look at complete version in *complete* folder


# Create download folder
$Out = 'C:\temp\ghidra-deps'
New-Item -ItemType Directory -Path $Out -Force

# Download files (Windows example + two jars). Add/remove lines for optional platform executables you need.
Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/com/google/protobuf/protoc/3.21.12/protoc-3.21.12-windows-x86_64.exe' -OutFile (Join-Path $Out 'protoc-3.21.12-windows-x86_64.exe')
Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/com/google/protobuf/protoc/3.21.12/protoc-3.21.12.jar' -OutFile (Join-Path $Out 'protoc-3.21.12.jar')
Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/3.21.12/protobuf-java-3.21.12.jar' -OutFile (Join-Path $Out 'protobuf-java-3.21.12.jar')

# Compute SHA-256 for each file and save to a text file (optional but recommended)
Get-ChildItem $Out | Where-Object {-not $_.PSIsContainer} | ForEach-Object {
  $hash = Get-FileHash -Path $_.FullName -Algorithm SHA256
  \"$($_.Name) $($hash.Hash)\" | Out-File -FilePath (Join-Path $Out 'SHA256SUMS.txt') -Append -Encoding utf8
}

# Copy to removable media (example: E:\). Adjust destination as needed
# Copy-Item -Path (Join-Path $Out '*') -Destination 'E:\ghidra-deps' -Recurse -Force
