Add-Type -AssemblyName System.Windows.Forms

# Initialize form
$form = New-Object Windows.Forms.Form
$form.Size = New-Object Drawing.Size @(800,600)
$form.Text = "AbuseIPDB Checker"

# Initialize input textbox
$inputBox = New-Object Windows.Forms.TextBox
$inputBox.Location = New-Object Drawing.Point @(25,25)
$inputBox.Size = New-Object Drawing.Size @(350,500)
$inputBox.Multiline = $true
$form.Controls.Add($inputBox)

# Initialize output textbox
$outputBox = New-Object Windows.Forms.TextBox
$outputBox.Location = New-Object Drawing.Point @(400,25)
$outputBox.Size = New-Object Drawing.Size @(350,500)
$outputBox.Multiline = $true
$outputBox.ReadOnly = $true
$form.Controls.Add($outputBox)

# Initialize button
$button = New-Object Windows.Forms.Button
$button.Text = "Check IPs"
$button.Location = New-Object Drawing.Point @(25,540)
$button.Size = New-Object Drawing.Size @(725,30)

$button.Add_Click({
    $outputBox.Text = ""
    $apiKey = "FIXME"
    $ipList = $inputBox.Text -split "[,`r`n ]" | ForEach-Object { $_.Trim() } | Where-Object { $_ } | Sort-Object | Get-Unique
    [System.Windows.Forms.MessageBox]::Show("IPs to check: " + ($ipList -join ', '))
    foreach($ip in $ipList) {
        if (![string]::IsNullOrEmpty($ip.Trim())) {
            $response = Invoke-RestMethod -Method GET -Uri "https://api.abuseipdb.com/api/v2/check?ipAddress=$ip&verbose=true" -Headers @{
                "Key" = $apiKey
                "Accept" = "application/json"
            }
        $country = if ($response.data.countryName) { $response.data.countryName } else { "N/A" }
        $countrycode = if ($response.data.countryCode) { $response.data.countryCode } else { "N/A" }
        $lastComment = if ($response.data.reports -and $response.data.reports.Count -gt 0) { $response.data.reports[0].comment } else { "N/A" }
        $result = "IP: $($response.data.ipAddress)`r`nScore: $($response.data.abuseConfidenceScore)`r`nCountry: $country`r`ncountrycode: $countrycode`r`nisp: $($response.data.isp)`r`ndomain: $($response.data.domain)`r`nisTor: $($response.data.isTor)`r`nLast Reported: $($response.data.lastReportedAt)`r`nLast Comment: $lastComment`r`n-------------------------`r`n"
        $outputBox.Text += $result
        }
    }
})

$form.Controls.Add($button)

# Show form
$form.ShowDialog()
