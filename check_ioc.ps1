[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '660,600'
$Form.text                       = "Virustotal Report"
$Form.TopMost                    = $false

$APIKeyLabel                     = New-Object System.Windows.Forms.Label
$APIKeyLabel.text                = "Enter your VirusTotal API Key:"
$APIKeyLabel.AutoSize            = $true
$APIKeyLabel.width               = 20
$APIKeyLabel.height              = 20
$APIKeyLabel.location            = New-Object System.Drawing.Point(10,20)
$APIKeyLabel.Font                = 'Microsoft Sans Serif,10'

$APIKeyTextbox                   = New-Object System.Windows.Forms.TextBox
$APIKeyTextbox.multiline         = $false
$APIKeyTextbox.width             = 400
$APIKeyTextbox.height            = 20
$APIKeyTextbox.location          = New-Object System.Drawing.Point(250,20)

$IOCsLabel                       = New-Object System.Windows.Forms.Label
$IOCsLabel.text                  = "Enter list of IOCs separated by comma or by return:"
$IOCsLabel.AutoSize              = $true
$IOCsLabel.width                 = 20
$IOCsLabel.height                = 20
$IOCsLabel.location              = New-Object System.Drawing.Point(10,50)
$IOCsLabel.Font                  = 'Microsoft Sans Serif,10'

$IOCsTextbox                     = New-Object System.Windows.Forms.TextBox
$IOCsTextbox.multiline           = $true
$IOCsTextbox.width               = 550
$IOCsTextbox.height              = 450
$IOCsTextbox.location            = New-Object System.Drawing.Point(10,80)

$SubmitButton                    = New-Object System.Windows.Forms.Button
$SubmitButton.text               = "Submit"
$SubmitButton.width              = 90
$SubmitButton.height             = 50
$SubmitButton.location           = New-Object System.Drawing.Point(565,300)
$SubmitButton.Font               = 'Microsoft Sans Serif,10'

$ResultTextbox                     = New-Object System.Windows.Forms.TextBox
$ResultTextbox.multiline           = $true
$ResultTextbox.width               = 550
$ResultTextbox.height              = 450
$ResultTextbox.location            = New-Object System.Drawing.Point(10,550)

$Form.controls.AddRange(@($APIKeyLabel,$APIKeyTextbox,$IOCsLabel,$IOCsTextbox,$ResultTextbox,$SubmitButton))

$SubmitButton.Add_Click({
    $APIKey = $APIKeyTextbox.Text
    $IOCs = ($IOCsTextbox.Text -split ",") -replace "`r`n", ""
    $resultString = ""

    Foreach ($IOC in $IOCs)
    {
        $uri = "https://www.virustotal.com/vtapi/v2/file/report?apikey=$APIKey&resource=$IOC"
        $result = Invoke-RestMethod -uri $uri
        $totalScore = $result.positives
        $result | Format-Table
        $resultString += "The total score for $IOC is $totalScore.`n"
    }
    $ResultTextbox.Text = $resultString
})


$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()
