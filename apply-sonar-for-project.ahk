#Requires AutoHotkey v2.0
#SingleInstance Force

^k:: {

    TargetFolder := DirSelect(A_WorkingDir, 1, "Chon project can ap dung sonarqube")
    if TargetFolder = ""
        return

    
    fileAppendToLine(TargetFolder "/settings.gradle", "springDependenciesManagementVersion", "    id 'org.sonarqube' version `"${sonarVersion}`" apply false")
    fileAppendToLine(TargetFolder "/gradle.properties", "mavenVersion", "sonarVersion=4.2.1.3168")
    FileAppend("`napply plugin: 'org.sonarqube'", TargetFolder "/build.gradle")

    sonarqubeCheck := "
                        (
                        # --------------------------------------------------------------------------------------------------
                        sonarqube-check:
                        image: nexus.cmctelecom.vn/eclipse-temurin:17-jdk-alpine
                        tags: ["sonar"]
                        stage: sonarqube-check
                        cache:
                            key: "${CI_JOB_NAME}"
                            paths:
                            - .sonar/cache
                        before_script:
                            # Make sure ./gradlew can runnable
                            - chmod a+x ./gradlew
                        script:
                            - ./gradlew sonar -Dsonar.qualitygate.wait=true
                        allow_failure: false
                        rules: 
                            - if: '$CI_MERGE_REQUEST_TARGET_BRANCH_NAME == "master"'
                        )"
    fileAppendToLine(TargetFolder "/.gitlab-ci.yml", "SonarQube scan", sonarqubeCheck)
    removeLine(TargetFolder "/.gitlab-ci.yml", "- if: '$CI_MERGE_REQUEST_TARGET_BRANCH_NAME == `"master`"'")
    fileAppendToLine(TargetFolder "/.gitlab-ci.yml", "test only apply for Sonarqube", "  - sonarqube-check")
    fileAppendToLine(TargetFolder "/.gitlab-ci.yml", "MANIFEST_PATH:", '  SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"  # Defines the location of the analysis task cache')


    GitBranch := "master"
    GitChheckoutBranch := "git checkout " GitBranch
    GitCreateBranchSonar := "git checkout -b son.ct1/add_sonarqube_check" 
    GitCommand := "git status"
    GitAddFile := "git add build.gradle settings.gradle .gitlab-ci.yml gradle.properties"
    GitCommit := "git commit -m `"add sonarqube check`""
    GitShowLog := "git log"
    TempFile := TargetFolder "/GitOutput.txt"

    ; Run the Git command in cmd and redirect the output to a file
    RunWait 'cmd.exe /c cd "' TargetFolder '" && ' GitChheckoutBranch ' > "' TempFile '"', , "Hide"
    RunWait 'cmd.exe /c cd "' TargetFolder '" && ' GitCreateBranchSonar ' > "' TempFile '"', , "Hide"
    RunWait 'cmd.exe /c cd "' TargetFolder '" && ' GitAddFile ' > "' TempFile '"', , "Hide"
    RunWait 'cmd.exe /c cd "' TargetFolder '" && ' GitCommit ' > "' TempFile '"', , "Hide"
    RunWait 'cmd.exe /c cd "' TargetFolder '" && ' GitCommand ' > "' TempFile '"', , "Hide"
    RunWait 'cmd.exe /c cd "' TargetFolder '" && ' GitShowLog ' > "' TempFile '"', , "Hide"


    ; Read the output from the file
    GitOutput := FileRead(TempFile)

    ; Clean up by deleting the temporary file
    FileDelete(TempFile)

    ; Display the output in a message box
    ; MsgBox(GitOutput)

    MsgBox "Apply sonarqube check done, gitoutput: " GitOutput, "Thong bao"
    ExitApp
}

fileAppendToLine(filePath, keyword, appendText)
{
    ; Read the file content
    FileContent := FileRead(filePath)
    if !FileContent
    {
        MsgBox "Could not read file!"
        return
    }

    ; Initialize a variable to store the modified content
    ModifiedContent := ""

    ; Split the content into lines and iterate
    for Line in StrSplit(FileContent, "`n")
    {
        ; Check if the line contains the keyword
        if InStr(Line, keyword)
        {
            ; Append text to this line
            Line .= appendText
        }

        ; Rebuild the modified content
        ModifiedContent .= Line "`n"
    }

    ; Write the modified content back to the file
    FileDelete(FilePath)  ; Delete the old file
    FileAppend(ModifiedContent, FilePath)  ; Write the new content
}

fileDeleteLineAtKeyword(filePath, keyword)
{
    ; Read the file content
    FileContent := FileRead(filePath)
    if !FileContent
    {
        MsgBox "Could not read file!"
        return
    }

    ; Initialize a variable to store the modified content
    ModifiedContent := ""

    ; Split the content into lines and iterate
    skip := false
    for Line in StrSplit(FileContent, "`n")
    {
        ; Check if the line contains the keyword
        if InStr(Line, keyword)
        {
            ; Append text to this line
            ; Line .= appendText
            skip := true
            continue
        }

        if !skip
        {
            ModifiedContent .= Line "`n"
            skip := false
        }
    }

    ; Write the modified content back to the file
    FileDelete(FilePath)  ; Delete the old file
    FileAppend(ModifiedContent, FilePath)  ; Write the new content
}

removeLine(FilePath, Keyword)
{
    ; Read the file content
    FileContent := FileRead(FilePath)
    if !FileContent {
        MsgBox "Could not read file!"
        return
    }

    ; Initialize a variable to store the modified content
    ModifiedContent := ""
    FoundKeyword := false  ; To track if the keyword has been found
    SkipNextLine := false  ; To track if the next line should be skipped

    ; Split the content into lines and iterate
    for Line in StrSplit(FileContent, "`n") {
        if SkipNextLine {
            SkipNextLine := false  ; Reset skip flag after skipping one line
            continue  ; Skip this line
        }

        ; Check if this line contains the keyword and it hasn't been found before
        if !FoundKeyword && InStr(Line, Keyword) {
            FoundKeyword := true
            SkipNextLine := true  ; Set the flag to skip the next line
        }

        ; Rebuild the modified content
        ModifiedContent .= Line "`n"
    }

    ; Write the modified content back to the file
    FileDelete(FilePath)  ; Delete the old file
    FileAppend(ModifiedContent, FilePath)  ; Write the new content
}