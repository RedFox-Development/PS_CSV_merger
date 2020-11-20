# PS_CSV_merger

PowerShell script that merges multiple csv, tsv or txt files into one.

<img src="https://api.iconify.design/mdi:powershell.svg?color=blue&height=24"/>


I created this ps1 - PowerShell - script for work use, but decided to push it here at GitHub so anyone can have it.


This script is used for merging multiple plain text files into one.


## Parameters

Script takes three (3) parameters

### runtype

Parameter -runtype will require 'merge' is the script is supposed to do merging of files.
Any other runtype or leaving this parameter unused will cause script execution to end.

### fileExtension

Parameter -fileExtension will require file extension that'll narrow the file types that'll be merged.
Accepted file extensions are `csv`, `tsv` and `txt`. Any other extension will cause script execution to end.

### directories

Parameter -directories will require an array of directory names that'll be looped through to merge selected file types into one.
Directory names needs to be at least subdirectories of working directory (where script was executed).
I.e. `-directories @('subdir1','subdir2/dir1','subdir3/dir2/dir3')`

## Execution

Script does not require administrator i.e. elevated privileges.

Script should be placed to parent directory of the directory containing the files that'll be merged.

I.e. if the files are in the directory `C:\Users\youruser\Documents\somefilestobemerged`, you should place the script at least one level down, i.e. `C:\Users\youruser\Documents`.

I created this script to be executed with another tool, but it works well without one too, straight from the PowerShell.

If you placed it to mentioned directory, PowerShell should give you following prompt:

`PS C:\Users\youruser\Documents>`

If this is not the case, you should probably switch to that directory so you can run the script.

When you are in correct directory, you are going to type in command.

Presumably you want to merge plain text files (csv,tsv,txt) to one.

Typing in `.\csv_merger.ps1 -runtype merge -fileExtension <csv/tsv/txt - select one> -directories @('somefilestobemerged')` will merge all the csv's, tsv's or txt's into one file, depending which one you selected.

It is not a catastrophe if you left fileExtension unused, since it will ask it from you.

### Scenarios of running the script

These all could happen when you run the script, depending on what parameters you typed in.

#### Successful run

#### Invalid fileExtension

#### Invalid runtype
