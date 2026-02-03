# Ghidra 12.1 - Download all init dependencies (no Java required)
# Run this on a machine WITH internet. Then copy the "dependencies" folder to the offline machine.
# Usage: .\Download-GhidraDependencies.ps1
#        Or: .\Download-GhidraDependencies.ps1 -OutputDir "D:\ghidra-deps"

param(
    [string]$OutputDir = (Join-Path $PSScriptRoot "dependencies\downloads")
)

$ErrorActionPreference = "Stop"
$release = "12.1"

$deps = @(
    @{ name = "java-sarif-2.1-modified.jar"; url = "https://github.com/NationalSecurityAgency/ghidra-data/raw/Ghidra_$release/lib/java-sarif-2.1-modified.jar" },
    @{ name = "dbgmodel.tlb"; url = "https://github.com/NationalSecurityAgency/ghidra-data/raw/Ghidra_$release/Debugger/dbgmodel.tlb" },
    @{ name = "AXMLPrinter2.jar"; url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/android4me/AXMLPrinter2.jar" },
    @{ name = "yajsw-stable-13.12.zip"; url = "https://sourceforge.net/projects/yajsw/files/yajsw/yajsw-stable-13.12/yajsw-stable-13.12.zip" },
    @{ name = "postgresql-15.13.tar.gz"; url = "https://ftp.postgresql.org/pub/source/v15.13/postgresql-15.13.tar.gz" },
    @{ name = "PyDev 9.3.0.zip"; url = "https://sourceforge.net/projects/pydev/files/pydev/PyDev%209.3.0/PyDev%209.3.0.zip" },
    @{ name = "cdt-8.6.0.zip"; url = "https://archive.eclipse.org/tools/cdt/releases/8.6/cdt-8.6.0.zip" },
    @{ name = "vs2012_x64.fidb"; url = "https://github.com/NationalSecurityAgency/ghidra-data/raw/Ghidra_$release/FunctionID/vs2012_x64.fidb" },
    @{ name = "vs2012_x86.fidb"; url = "https://github.com/NationalSecurityAgency/ghidra-data/raw/Ghidra_$release/FunctionID/vs2012_x86.fidb" },
    @{ name = "vs2015_x64.fidb"; url = "https://github.com/NationalSecurityAgency/ghidra-data/raw/Ghidra_$release/FunctionID/vs2015_x64.fidb" },
    @{ name = "vs2015_x86.fidb"; url = "https://github.com/NationalSecurityAgency/ghidra-data/raw/Ghidra_$release/FunctionID/vs2015_x86.fidb" },
    @{ name = "vs2017_x64.fidb"; url = "https://github.com/NationalSecurityAgency/ghidra-data/raw/Ghidra_$release/FunctionID/vs2017_x64.fidb" },
    @{ name = "vs2017_x86.fidb"; url = "https://github.com/NationalSecurityAgency/ghidra-data/raw/Ghidra_$release/FunctionID/vs2017_x86.fidb" },
    @{ name = "vs2019_x64.fidb"; url = "https://github.com/NationalSecurityAgency/ghidra-data/raw/Ghidra_$release/FunctionID/vs2019_x64.fidb" },
    @{ name = "vs2019_x86.fidb"; url = "https://github.com/NationalSecurityAgency/ghidra-data/raw/Ghidra_$release/FunctionID/vs2019_x86.fidb" },
    @{ name = "vsOlder_x64.fidb"; url = "https://github.com/NationalSecurityAgency/ghidra-data/raw/Ghidra_$release/FunctionID/vsOlder_x64.fidb" },
    @{ name = "vsOlder_x86.fidb"; url = "https://github.com/NationalSecurityAgency/ghidra-data/raw/Ghidra_$release/FunctionID/vsOlder_x86.fidb" },
    @{ name = "z3-4.13.0-x64-glibc-2.31.zip"; url = "https://github.com/Z3Prover/z3/releases/download/z3-4.13.0/z3-4.13.0-x64-glibc-2.31.zip" },
    @{ name = "z3-4.13.0-arm64-osx-11.0.zip"; url = "https://github.com/Z3Prover/z3/releases/download/z3-4.13.0/z3-4.13.0-arm64-osx-11.0.zip" },
    @{ name = "z3-4.13.0-x64-osx-11.7.10.zip"; url = "https://github.com/Z3Prover/z3/releases/download/z3-4.13.0/z3-4.13.0-x64-osx-11.7.10.zip" },
    @{ name = "z3-4.13.0-x64-win.zip"; url = "https://github.com/Z3Prover/z3/releases/download/z3-4.13.0/z3-4.13.0-x64-win.zip" },
    @{ name = "protobuf-6.31.0-py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/ee/01/1ed1d482960a5718fd99c82f6d79120181947cfd4667ec3944d448ed44a3/protobuf-6.31.0-py3-none-any.whl" },
    @{ name = "psutil-5.9.8.tar.gz"; url = "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz" },
    @{ name = "setuptools-80.9.0-py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/a3/dc/17031897dae0efacfea57dfd3a82fdd2a2aeb58e0ff71b77b87e44edc772/setuptools-80.9.0-py3-none-any.whl" },
    @{ name = "wheel-0.45.1-py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/0b/2c/87f3254fd8ffd29e4c02732eee68a83a1d3c346ae39bc6822dcbcb697f2b/wheel-0.45.1-py3-none-any.whl" },
    @{ name = "pybag-2.2.16-py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/5e/a2/52084698c0a3c7e7a94ddfff26f83df09a50781b8436f6f203f5de0a457c/pybag-2.2.16-py3-none-any.whl" },
    @{ name = "capstone-5.0.6-py3-none-win_amd64.whl"; url = "https://files.pythonhosted.org/packages/da/72/ff7894c2fb5716d9a3ce9c27ba34b29d991a11d8442d2ef0fcdc5564ba7e/capstone-5.0.6-py3-none-win_amd64.whl" },
    @{ name = "comtypes-1.4.13-py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/66/95/f30c80615fda0d3c0ee6493ac9db61183313b43499b62dec136773b0e870/comtypes-1.4.13-py3-none-any.whl" },
    @{ name = "pywin32-311-cp313-cp313-win_amd64.whl"; url = "https://files.pythonhosted.org/packages/e3/28/e0a1909523c6890208295a29e05c2adb2126364e289826c0a8bc7297bd5c/pywin32-311-cp313-cp313-win_amd64.whl" },
    @{ name = "win32more-0.7.0-py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/92/3a/658eb3ba88f067662be280f8f1aec07a70c96bac77e9edc48b1be38e446b/win32more-0.7.0-py3-none-any.whl" },
    @{ name = "win32more_appsdk-0.7.3-py2.py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/f6/49/cff21fc3adcac1fe19f9f2e50278553fe13b9ac702be569c97f85292481d/win32more_appsdk-0.7.3-py2.py3-none-any.whl" },
    @{ name = "win32more_core-0.7.0-py2.py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/81/bc/7c1c5609f835d3e719c944714638a7a70bbfef6b990c251c32c1cd82d67a/win32more_core-0.7.0-py2.py3-none-any.whl" },
    @{ name = "win32more_microsoft_graphics_win2d-0.7.1.3.2-py2.py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/b5/6d/d58b223be7cff571527d91a3626089cb4da614dcba461811dcf18449f0f9/win32more_microsoft_graphics_win2d-0.7.1.3.2-py2.py3-none-any.whl" },
    @{ name = "win32more_microsoft_web_webview2-0.7.1.0.3650.58-py2.py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/6c/8e/fdfc9f796aad6b622ff197b3e58c9689db95482dbf7817cd99d351b54719/win32more_microsoft_web_webview2-0.7.1.0.3650.58-py2.py3-none-any.whl" },
    @{ name = "win32more_microsoft_windows_sdk_contracts-0.7.10.0.26100.6901-py2.py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/56/d7/0bb36964811a23f262cdddb1e5b91fdbd2f494990d48e657f15108f04855/win32more_microsoft_windows_sdk_contracts-0.7.10.0.26100.6901-py2.py3-none-any.whl" },
    @{ name = "win32more_microsoft_windows_sdk_win32metadata-0.7.68.0.4-py2.py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/e5/37/8706eb126fc52e59526304aa89ee30771a894e489aa0ea835f101e499b17/win32more_microsoft_windows_sdk_win32metadata-0.7.68.0.4-py2.py3-none-any.whl" },
    @{ name = "win32more_microsoft_windowsappsdk-0.7.1.8.251106002-py2.py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/ef/7c/9630708dd252e0c5c7c9975d52ba0deea996e9b0cf29784d521ac30f3a48/win32more_microsoft_windowsappsdk-0.7.1.8.251106002-py2.py3-none-any.whl" },
    @{ name = "packaging-25.0-py3-none-any.whl"; url = "https://files.pythonhosted.org/packages/20/12/38679034af332785aac8774540895e234f4d07f7545804097de4b666afd8/packaging-25.0-py3-none-any.whl" },
    @{ name = "jpype1-1.5.2-cp313-cp313-macosx_10_13_universal2.whl"; url = "https://files.pythonhosted.org/packages/76/be/b37005bec457b94eaaf637a663073b7c5df70113fd4ae4865f6e386c612f/jpype1-1.5.2-cp313-cp313-macosx_10_13_universal2.whl" },
    @{ name = "jpype1-1.5.2-cp313-cp313-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"; url = "https://files.pythonhosted.org/packages/20/a3/00a265d424f7d47e0dc547df2320225ce0143fec671faf710def41404b8c/jpype1-1.5.2-cp313-cp313-manylinux_2_17_aarch64.manylinux2014_aarch64.whl" },
    @{ name = "jpype1-1.5.2-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"; url = "https://files.pythonhosted.org/packages/6d/d0/191db2e9ab6ae7029368a488c9d88235966843b185aba7925e54aa0c0013/jpype1-1.5.2-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl" },
    @{ name = "jpype1-1.5.2-cp313-cp313-win_amd64.whl"; url = "https://files.pythonhosted.org/packages/e3/b7/e1787633b41d609320b41d0dd87fe3118598210609e4e3f6cef93cfcef40/jpype1-1.5.2-cp313-cp313-win_amd64.whl" },
    @{ name = "jpype1-1.5.2-cp312-cp312-macosx_10_9_universal2.whl"; url = "https://files.pythonhosted.org/packages/8d/e4/0c27352e8222dcc0e3ce44b298015072d2057d08dd353541c980a31d26c9/jpype1-1.5.2-cp312-cp312-macosx_10_9_universal2.whl" },
    @{ name = "jpype1-1.5.2-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"; url = "https://files.pythonhosted.org/packages/fa/4c/e0200a6e3fed5cda79e926c2a8a610676f04948f89d7e38d93c7d4b21be9/jpype1-1.5.2-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl" },
    @{ name = "jpype1-1.5.2-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"; url = "https://files.pythonhosted.org/packages/74/f3/1cd4332076ed0421e703412f47f15f43af170809435c57ba3162edc80d4b/jpype1-1.5.2-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl" },
    @{ name = "jpype1-1.5.2-cp312-cp312-win_amd64.whl"; url = "https://files.pythonhosted.org/packages/74/dd/7408d4beae755de6fcd07c76b2f0bacabc0461b43fba83811c1f7c22440e/jpype1-1.5.2-cp312-cp312-win_amd64.whl" },
    @{ name = "jpype1-1.5.2-cp311-cp311-macosx_10_9_universal2.whl"; url = "https://files.pythonhosted.org/packages/35/a0/638186a75026a02286041e4a0449b1dff799a3914dc1c0716ef9b9367b73/jpype1-1.5.2-cp311-cp311-macosx_10_9_universal2.whl" },
    @{ name = "jpype1-1.5.2-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"; url = "https://files.pythonhosted.org/packages/0e/78/95db2eb3c8a7311ee08a2c237cea24828859db6a6cb5e901971d3f5e49da/jpype1-1.5.2-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl" },
    @{ name = "jpype1-1.5.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"; url = "https://files.pythonhosted.org/packages/0b/7d/9fdbbc1a574be43f9820735ca8df0caf8b159856201d9b21fd73932342bc/jpype1-1.5.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl" },
    @{ name = "jpype1-1.5.2-cp311-cp311-win_amd64.whl"; url = "https://files.pythonhosted.org/packages/0e/b9/4dfb38a7f4efb21f71df7344944a8d9a23e30d0503574e455af6ce4f1a56/jpype1-1.5.2-cp311-cp311-win_amd64.whl" },
    @{ name = "jpype1-1.5.2-cp310-cp310-macosx_10_9_universal2.whl"; url = "https://files.pythonhosted.org/packages/c7/f2/b2efcad1ea5a541f125218e4eb1529ebb8ca18941264c879f3e89a36dc35/jpype1-1.5.2-cp310-cp310-macosx_10_9_universal2.whl" },
    @{ name = "jpype1-1.5.2-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"; url = "https://files.pythonhosted.org/packages/c0/c6/63538d160c17e837f62d29ba4163bc444cef08c29cd3f3b8090691c1869c/jpype1-1.5.2-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl" },
    @{ name = "jpype1-1.5.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"; url = "https://files.pythonhosted.org/packages/97/0a/cbe03759331c640aa5862f974028122a862b08935a0b11b8fa6f6e46c26b/jpype1-1.5.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl" },
    @{ name = "jpype1-1.5.2-cp310-cp310-win_amd64.whl"; url = "https://files.pythonhosted.org/packages/22/18/0a51845ca890ffdc72f4d71a0c2be334b887c5bb6812207efe5ad45afcb3/jpype1-1.5.2-cp310-cp310-win_amd64.whl" },
    @{ name = "jpype1-1.5.2-cp39-cp39-macosx_10_9_x86_64.whl"; url = "https://files.pythonhosted.org/packages/05/71/590b2a91b43763aa27eac2c63803542a2878a4d8c600b81aa694d3fde919/jpype1-1.5.2-cp39-cp39-macosx_10_9_x86_64.whl" },
    @{ name = "jpype1-1.5.2-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"; url = "https://files.pythonhosted.org/packages/77/6b/130fb6d0c43976b4e129c6bc19daf0e25c42fc38c5096ed92c4105bfd2c4/jpype1-1.5.2-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl" },
    @{ name = "jpype1-1.5.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"; url = "https://files.pythonhosted.org/packages/77/91/f08a719461a390b48d9096b50f1f4a49ee281007ec192e51073090d3d8b7/jpype1-1.5.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl" },
    @{ name = "jpype1-1.5.2-cp39-cp39-win_amd64.whl"; url = "https://files.pythonhosted.org/packages/e5/cf/344e1f81f1e8c651ec23dfa9fe4b91f6e1d699b36f610a547ba85ee7fb16/jpype1-1.5.2-cp39-cp39-win_amd64.whl" },
    @{ name = "jpype1-1.5.2.tar.gz"; url = "https://files.pythonhosted.org/packages/bd/68/47fa634cbd0418cbca86355e9421425f5892ee994f7338106327e49f9117/jpype1-1.5.2.tar.gz" }
)

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
Write-Host "Downloading to: $OutputDir"
Write-Host "Total files: $($deps.Count)"
$n = 0
foreach ($d in $deps) {
    $n++
    $out = Join-Path $OutputDir $d.name
    if (Test-Path $out) {
        Write-Host "[$n/$($deps.Count)] Skip (exists): $($d.name)"
        continue
    }
    Write-Host "[$n/$($deps.Count)] $($d.name)"
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $d.url -OutFile $out -UseBasicParsing
    } catch {
        Write-Warning "Failed: $($d.name) - $($_.Exception.Message)"
    }
}
Write-Host "Done. Copy the entire folder that contains 'downloads' (e.g. dependencies) to the offline machine, then run gradlew init there."
