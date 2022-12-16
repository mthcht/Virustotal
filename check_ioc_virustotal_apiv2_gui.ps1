$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '800,680'
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
$APIKeyTextbox.location          = New-Object System.Drawing.Point(210,20)

$IOCsLabel                       = New-Object System.Windows.Forms.Label
$IOCsLabel.text                  = "Enter list of IOCs separated by comma or by return:"
$IOCsLabel.AutoSize              = $true
$IOCsLabel.width                 = 20
$IOCsLabel.height                = 20
$IOCsLabel.location              = New-Object System.Drawing.Point(10,50)
$IOCsLabel.Font                  = 'Microsoft Sans Serif,10'

$IOCsTextbox                     = New-Object System.Windows.Forms.TextBox
$IOCsTextbox.multiline           = $true
$IOCsTextbox.width               = 650
$IOCsTextbox.height              = 250
$IOCsTextbox.location            = New-Object System.Drawing.Point(10,80)

$ResultLabel                     = New-Object System.Windows.Forms.Label
$ResultLabel.text                = "Results:"
$ResultLabel.AutoSize            = $true
$ResultLabel.width               = 20
$ResultLabel.height              = 20
$ResultLabel.location            = New-Object System.Drawing.Point(10,340)
$ResultLabel.Font                = 'Microsoft Sans Serif,10'

$ResultTextbox                    = New-Object System.Windows.Forms.RichTextBox
$ResultTextbox.multiline          = $true
$ResultTextbox.width              = 650
$ResultTextbox.height             = 250
$ResultTextbox.location           = New-Object System.Drawing.Point(10,360)

$SubmitButton                    = New-Object System.Windows.Forms.Button
$SubmitButton.text               = "Submit"
$SubmitButton.width              = 90
$SubmitButton.height             = 50
$SubmitButton.location           = New-Object System.Drawing.Point(680,180)
$SubmitButton.Font               = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($APIKeyLabel,$APIKeyTextbox,$IOCsLabel,$IOCsTextbox,$ResultLabel,$ResultTextbox,$SubmitButton))


$SubmitButton.Add_Click({
    $APIKey = $APIKeyTextbox.Text
    $IOCs = $IOCsTextbox.Text -replace "`r`n", ","
    $IOCs = ($IOCs -split ",")

    $resultString = ""

    Foreach ($IOC in $IOCs)
    {
        try{ 
            $uri = "https://www.virustotal.com/vtapi/v2/file/report?apikey=$APIKey&resource=$IOC"
            $url = "https://www.virustotal.com/gui/search/$IOC"
            $result = Invoke-RestMethod -uri $uri
            $totalScore = $result.positives
        }
        catch{
            $totalScore = "error: $_ "
        }
        if ($totalScore -eq $null){ $totalScore = 0 }
        $result | Format-Table
        $resultString += "`r`n $IOC = $totalScore `r`n $url `r`n"

    }
    $ResultTextbox.Text = $resultString
})

$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()

$ResultTextbox.AppendText("link: ")
$ResultTextbox.Select($ResultTextbox.Text.Length - 6, 6)
$ResultTextbox.SelectedText = [System.String]::Empty
$ResultTextbox.InsertLink("link", $url)
