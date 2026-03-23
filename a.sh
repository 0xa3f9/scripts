#!/bin/bash

$token = $env:GH_TOKEN
$user  = $env:GH_USER
$repo  = $env:GH_REPO

Add-Type -AssemblyName System.Windows.Forms, System.Drawing
$Screen = [System.Windows.Forms.Screen]::PrimaryScreen
$Bitmap = New-Object System.Drawing.Bitmap $Screen.Bounds.Width, $Screen.Bounds.Height
$Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)
$Graphics.CopyFromScreen($Screen.Bounds.Location, [System.Drawing.Point]::Empty, $Screen.Bounds.Size)

$ms = New-Object System.IO.MemoryStream
$Bitmap.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
$base64Content = [Convert]::ToBase64String($ms.ToArray())

$Graphics.Dispose(); $Bitmap.Dispose(); $ms.Dispose()

$fileName = "ss-$(Get-Date -Format 'yyyyMMdd-HHmmss').png"
$apiUrl = "https://api.github.com/repos/$user/$repo/contents/$fileName"
$body = @{
    message = "New Screenshot"
    content = $base64Content
} | ConvertTo-Json

$headers = @{
    "Authorization" = "token $token"
    "Accept"        = "application/vnd.github.v3+json"
}

try {
    $res = Invoke-RestMethod -Uri $apiUrl -Method Put -Headers $headers -Body $body
    Write-Host "Screenshot Public Link: https://raw.githubusercontent.com/$user/$repo/master/$fileName" -ForegroundColor Cyan
} catch {
    Write-Error "Upload failed: $_"
}






