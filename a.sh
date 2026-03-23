#!/bin/bash

$token = $GH_TOKEN
$user  = $GH_USER
$repo  = $GH_REPO

$textContent = "hello from remote"
$base64Content = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($textContent))
$fileName = "msg-$(Get-Date -Format 'HHmmss').txt"

$apiUrl = "https://api.github.com/repos/$user/$repo/contents/$fileName"
$body = @{ message="remote upload"; content=$base64Content } | ConvertTo-Json
$headers = @{ "Authorization"="token $token"; "Accept"="application/vnd.github.v3+json" }

try {
    Invoke-RestMethod -Uri $apiUrl -Method Put -Headers $headers -Body $body -ErrorAction Stop
    Write-Host "Uploaded $fileName to GitHub!" -ForegroundColor Green
} catch {
    Write-Host "Failed: $_" -ForegroundColor Red
}
