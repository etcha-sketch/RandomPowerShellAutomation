# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

function select-time
{
	Add-Type -AssemblyName System.Windows.Forms
	
	# Main Form
	$mainForm = New-Object System.Windows.Forms.Form
	$font = New-Object System.Drawing.Font(“Consolas”, 13)
	$mainForm.Text = ” Select Time”
	$mainForm.Font = $font
	$mainForm.ForeColor = “White”
	$mainForm.BackColor = “DarkCyan”
	$mainForm.Width = 300 #300
	$mainForm.Height = 180 #180
	
	# DatePicker Label
	$datePickerLabel = New-Object System.Windows.Forms.Label
	$datePickerLabel.Text = “Date”
	$datePickerLabel.Location = “15, 10”
	$datePickerLabel.Height = 22
	$datePickerLabel.Width = 90
	$mainForm.Controls.Add($datePickerLabel)
	
	# MaxTimePicker Label
	$maxTimePickerLabel = New-Object System.Windows.Forms.Label
	$maxTimePickerLabel.Text = “Time”
	$maxTimePickerLabel.Location = “15, 45”
	$maxTimePickerLabel.Height = 22
	$maxTimePickerLabel.Width = 90
	$mainForm.Controls.Add($maxTimePickerLabel)
	
	# DatePicker
	$datePicker = New-Object System.Windows.Forms.DateTimePicker
	$datePicker.Location = “110, 7”
	$datePicker.Width = “150”
	$datePicker.Format = [windows.forms.datetimepickerFormat]::custom
	$datePicker.CustomFormat = “MM/dd/yyyy”
	$mainForm.Controls.Add($datePicker)
	
	# MaxTimePicker
	$maxTimePicker = New-Object System.Windows.Forms.DateTimePicker
	$maxTimePicker.Location = “110, 42”
	$maxTimePicker.Width = “150”
	$maxTimePicker.Format = [windows.forms.datetimepickerFormat]::custom
	$maxTimePicker.CustomFormat = “HH:mm:ss”
	$maxTimePicker.ShowUpDown = $TRUE
	$mainForm.Controls.Add($maxTimePicker)
	
	#Reboot Checkbox
	$rebootcheckbox = New-Object System.Windows.Forms.CheckBox
	$rebootcheckbox.Location = New-Object System.Drawing.Size(30, 80)
	$rebootcheckbox.Size = New-Object System.Drawing.Size(100, 20)
	$rebootcheckbox.Text = "Reboot"
	$rebootcheckbox.Checked = $true
	$mainForm.Controls.Add($rebootcheckbox)
	
	#Shutdown Checkbox
	$shutdowncheckbox = New-Object System.Windows.Forms.CheckBox
	$shutdowncheckbox.Location = New-Object System.Drawing.Size(130, 80)
	$shutdowncheckbox.Size = New-Object System.Drawing.Size(120, 20)
	$shutdowncheckbox.Text = "Shutdown"
	$shutdowncheckbox.Checked = $false
	$mainForm.Controls.Add($shutdowncheckbox)
		
	#Logic to only have one check
	$rebootcheckbox.add_CheckedChanged({
		if ($shutdowncheckbox.CheckState -eq "Checked")
		{
			$shutdowncheckbox.CheckState = "Unchecked"
		}
	
	})
	$shutdowncheckbox.add_CheckedChanged({
		if ($rebootcheckbox.CheckState -eq "Checked")
		{
			$rebootcheckbox.CheckState = "UnChecked"
		}
		
	})
	
	# OK Button
	$okButton = New-Object System.Windows.Forms.Button
	$okButton.Location = “15, 110”
	$okButton.ForeColor = “Black”
	$okButton.BackColor = “White”
	$okButton.Text = “OK”
	$okButton.add_Click({$mainForm.close()})
	$mainForm.Controls.Add($okButton)
	
	[void] $mainForm.ShowDialog()
	
	
	[datetime]$time = "$("{0:yyyy-MM-dd}" -f ($mainForm.Controls.value[0])) $("{0:HH:mm:ss}" -f ($mainForm.Controls.value[1]))"
	
	if ($rebootcheckbox.CheckState -eq "Checked")
	{
		return "reboot", $time
	}
	elseif ($shutdowncheckbox.CheckState -eq "Checked")
	{
		return "shutdown", $time
	}
	else
	{
		return "ERROR"
	}
}

function calculate-seconds
{
	param(
	[datetime]$selecteddate = ((Get-date).AddHours(3))
	)
	$currenttime = Get-Date
	$seconds = [math]::Ceiling((($selecteddate) - ($currenttime)).TotalSeconds)
	
	return $seconds
}


function Schedule-Reboot
{
	# Abort any other scheduled reboot/shutdown.
	try
	{
		shutdown /a
	}
	catch
	{}
	
	
	$selectedtime = select-time
	$calculatedseconds = calculate-seconds -selecteddate $selectedtime[1]
	
	if ($selectedtime[0] -eq "reboot")
	{
		shutdown /r /t $(($calculatedseconds).ToString()) /c "Powershell Automated Scheduled Reboot"
	}
	elseif ($selectedtime[0] -eq "shutdown")
	{
		shutdown /s /t $(($calculatedseconds).ToString()) /c "Powershell Automated Scheduled Shutdown"
	}
	else
	{
		write-host "ERROR"
	}
}
