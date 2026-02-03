
Simple demo with only 3 classes  

#### Please run example in *basic* folder;  
#### Then try to look at complete version in *complete* folder


$Out = 'C:\temp\ghidra-deps'
New-Item -ItemType Directory -Path $Out -Force

# Download the Windows protoc and the protobuf-java runtime jar
Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/com/google/protobuf/protoc/3.21.12/protoc-3.21.12-windows-x86_64.exe' -OutFile (Join-Path $Out 'protoc-3.21.12-windows-x86_64.exe')
Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/3.21.12/protobuf-java-3.21.12.jar' -OutFile (Join-Path $Out 'protobuf-java-3.21.12.jar')

# (Optional) download additional platform executables if you build on those platforms
# Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/com/google/protobuf/protoc/3.21.12/protoc-3.21.12-linux-x86_64.exe' -OutFile (Join-Path $Out 'protoc-3.21.12-linux-x86_64.exe')
# Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/com/google/protobuf/protoc/3.21.12/protoc-3.21.12-linux-aarch_64.exe' -OutFile (Join-Path $Out 'protoc-3.21.12-linux-aarch_64.exe')
# Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/com/google/protobuf/protoc/3.21.12/protoc-3.21.12-osx-x86_64.exe' -OutFile (Join-Path $Out 'protoc-3.21.12-osx-x86_64.exe')
# Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/com/google/protobuf/protoc/3.21.12/protoc-3.21.12-osx-aarch_64.exe' -OutFile (Join-Path $Out 'protoc-3.21.12-osx-aarch_64.exe')

# (Optional) create a checksum file for verification
Get-ChildItem $Out | Where-Object {-not $_.PSIsContainer} | ForEach-Object {
  $hash = Get-FileHash -Path $_.FullName -Algorithm SHA256
  \"$($_.Name) $($hash.Hash)\" | Out-File -FilePath (Join-Path $Out 'SHA256SUMS.txt') -Append -Encoding utf8
}
