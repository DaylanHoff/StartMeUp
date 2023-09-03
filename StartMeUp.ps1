#  - MUST RUN THIS COMMAND BEFORE YOU RUN THE SCRIPT
#    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

#---------- Includes ----------
#---------- Includes ----------

#---------- Paramiters ----------
#---------- Paramiters ----------


#---------- Functions ----------
function userInput {
    param(
        [Parameter(Mandatory=$True)][string]$prompt,
        [Parameter(Mandatory=$True)]$responses
    )
    while($true) {
        $value = Read-Host $prompt
        if($responses -contains $value) {
            return $value
        }
        else {
            Write-Host 'Please enter a valid input..' $responses
        }
    }
}
#---------- Functions ----------


#---------- Execution ----------
mkdir c:/Personal

iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

if((userInput "(RECOMENDED) Would you like to install notepad++? ( Y/N )" @('Y','N')) -eq 'Y') {
    choco install -y notepadplusplus   
}
if((userInput "(RECOMENDED) Would you like to install Visual Studios Code? ( Y/N )" @('Y','N')) -eq 'Y') {
    choco install -y vscode
}
if((userInput "(OPTIONAL) Would you like to install sublime text? ( Y/N )" @('Y','N')) -eq 'Y') {
    choco install -y sublimetext4
}
if((userInput "(OPTIONAL) Would you like to install Atom? ( Y/N )" @('Y','N')) -eq 'Y') {
    choco install -y Atom
}
if((userInput "(OPTIONAL) Would you like to install nano? ( Y/N )" @('Y','N')) -eq 'Y') {
    choco install -y nano
}
if((userInput "(OPTIONAL) Would you like to install Brave browser?( Y/N )" @('Y','N')) -eq 'Y') {
    choco install brave
}
Write-Host "`nInstalling Required applications..`n"
choco install -y git.install
choco install -y sharex
choco install -y vcredist-all
choco install -y GoogleChrome
choco install -y 7zip
choco install -y Everything
choco install -y nodejs.install
choco install -y python
choco install -y postman
choco install -y mongodb-compass

$question = userInput 'Would you like to change the default editor of git from vim? ( Y/N )' @('Y','N')
if($question -eq 'Y') {
    $question = userInput "What editor would you like to choose?`n1. Notepad++`n2. nano" @('1','2')
    Write-Host $question
}
Write-Host "ATTENTION: YOU NEED TO CREATE A PERSON ACCESS TOKEN TO CONTINUE!" -ForegroundColor Red
Write-Host "SELECT API AND ALL READ PERMISSIONS WHEN CREATING YOUR PAT..`n" -ForegroundColor Red
Write-Host "If you do not wish to clone the repositories press CTRL + C to cancel now..`n" -ForegroundColor Yellow

for (($i = 3); $i -gt 0; $i--)
{
   Write-Host "Resuming in: $i" -ForegroundColor Blue
   sleep 1
}

#Start-Process "https://github.com/settings/tokens"
$githubUsername = $(Write-Host "`nEnter your USERNAME: " -ForegroundColor Green; Read-Host)
$personalAccessToken = $(Write-Host "`nEnter your PAT: " -ForegroundColor Green; Read-Host)

# Replace with the path where you want to clone the repositories
$clonePath = "c:/Personal"

# API endpoint for listing repositories
$reposApiUrl = "https://api.github.com/users/$githubUsername/repos"

# Create a header with the authorization token
$headers = @{
    Authorization = "Bearer $personalAccessToken"
    Accept = "application/vnd.github.v3+json"
}

# Get the list of repositories
$repos = Invoke-RestMethod -Uri $reposApiUrl -Headers $headers

# Loop through each repository and clone
foreach ($repo in $repos) {
    $repoName = $repo.name
    $cloneUrl = $repo.clone_url
    $repoPath = Join-Path -Path $clonePath -ChildPath $repoName
    
    Write-Host "Cloning $repoName..."
    git clone $cloneUrl $repoPath
    Write-Host "Cloned $repoName to $repoPath"
}
