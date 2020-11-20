<#
.SYNOPSIS
Merge multiple csv, tsv or txt files to one file.

.DESCRIPTION
Merge multiple csv, tsv or txt files from directory to one file.
Script is able to run merging for multiple directories on one run. 
I.e. script could be run in multiple directories and for each directory it would merge all files of given extension to one.
File extension selection is done by giving the script a parameter.
Directory selection is done by giving the script an array of directory names as a parameter.
Script requires runtype parameter 'merge' to actually merge files.
Script will include header row of the first file, but it'll ignore the header for the rest of the files.
Script invokes system balloon notification on completion, invalid file extension and when runtype is other than 'merge'.

Name:         csv_merger.ps1
Author:       RedFoxFinn
Organisation: RedFox Development
Date:         2020-11-19
Script was originally developed for usage in Unisafe Oy.

.EXAMPLE
PS C:\path\to\script> .\csv_merger.ps1 -runtype merge -fileExtension csv -directories @('dir1', 'dir2')

.PARAMETER runtype
Script needs this parameter to be specified as 'merge' to set merging mode active. Any other runtype will end execution.

.PARAMETER fileExtension
Script needs this parameter to be specified as 'csv', 'tsv' or 'txt'. Any other file extension will be considered as invalid.
Mandatory parameter.

.PARAMETER directories
Script needs an array of directory names (needs to be subdirectory of the scripts working directory or any subdirectory within subdirectories of it) of directories to be processed for this parameter.
I.e. @('dir1', 'subdir1/dir2')

.LINK
https://github.com/RedFox-Development

#>


param ($runtype='dry', [Parameter(Mandatory)]$fileExtension, $directories);

Add-Type -AssemblyName System.Windows.Forms;

$runDirectory = Get-Location;

$acceptedExtensions = @('csv','tsv','txt');

switch ($runtype) {
    'merge' {
        if ($acceptedExtensions -contains $fileExtension) {
            foreach ($directory in $directories) {
                $dir = "$runDirectory"+ "\" + $directory;
                $getFirstLine = $true;
                Get-ChildItem "$dir\*.$fileExtension" | foreach {
                    $filePath = $_;
                    $lines = Get-Content $filePath;
                    $linesToWrite = switch($getFirstLine) {
                        $true {$lines}
                        $false {$lines | Select -Skip 1}
                    }
                    $getFirstLine = $false;
                    Add-Content "$dir\$directory.$fileExtension" $linesToWrite;
                    write-host "$filePath entries added";
                }
            }
            $global:balloon = New-Object System.Windows.Forms.NotifyIcon;
            $path = (Get-Process -id $pid).Path;
            $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path);
            $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::None;
            $balloon.BalloonTipText = "CSV merger | $fileExtension";
            $balloon.BalloonTipTitle = "Script was run in $runtype mode. `nMerging of $fileExtension completed.";
            $balloon.Visible = $true;
            $balloon.ShowBalloonTip(60000);
        } else {
            $global:balloon = New-Object System.Windows.Forms.NotifyIcon;
            $path = (Get-Process -id $pid).Path;
            $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path); 
            $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::None;
            $balloon.BalloonTipText = "CSV merger | $fileExtension";
            $balloon.BalloonTipTitle = "$fileExtension is not supported. Nothing was changed.";
            $balloon.Visible = $true;
            $balloon.ShowBalloonTip(60000);
        }
        break;
    }
    default {
        $global:balloon = New-Object System.Windows.Forms.NotifyIcon;
        $path = (Get-Process -id $pid).Path;
        $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path); 
        $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::None;
        $balloon.BalloonTipText = "CSV merger | dry run";
        $balloon.BalloonTipTitle = "Script was run in dry mode. Nothing was changed.";
        $balloon.Visible = $true;
        $balloon.ShowBalloonTip(60000);
        break;
    }
}