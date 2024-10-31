#Requires AutoHotkey v2.0
#SingleInstance Force
#Include file-helper.ahk

^k:: {

    TargetFolder := DirSelect(A_WorkingDir, 1, "Chon project can ap dung sonarqube")
    if TargetFolder = ""
        return

    
    FileAppendToLine(TargetFolder "/settings.gradle", "springDependenciesManagementVersion", "    id 'org.sonarqube' version `"${sonarVersion}`" apply false")
    FileAppendToLine(TargetFolder "/gradle.properties", "mavenVersion", "sonarVersion=4.2.1.3168")
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
    FileAppendToLine(TargetFolder "/.gitlab-ci.yml", "SonarQube scan", sonarqubeCheck)
    RemoveLineAfterKeyword(TargetFolder "/.gitlab-ci.yml", "- if: '$CI_MERGE_REQUEST_TARGET_BRANCH_NAME == `"master`"'")
    FileAppendToLine(TargetFolder "/.gitlab-ci.yml", "test only apply for Sonarqube", "  - sonarqube-check")
    FileAppendToLine(TargetFolder "/.gitlab-ci.yml", "MANIFEST_PATH:", '  SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"  # Defines the location of the analysis task cache')


    GitBranch := "master"
    GitChheckoutBranchMaster := "git checkout master"
    GitCreateBranchSonar := "git checkout -b son.ct1/add_sonarqube_check" 
    GitPushOriginBranchSonar := "git push origin son.ct1/add_sonarqube_check"
    GitCommand := "git status"
    GitAddFile := "git add build.gradle settings.gradle .gitlab-ci.yml gradle.properties"
    GitCommit := "git commit -m `"add sonarqube check`""
    GitShowLog := "git log"
    TempFile := TargetFolder "/GitOutput.txt"

    ; Run the Git command in cmd and redirect the output to a file
    RunWait 'cmd.exe /c cd "' TargetFolder '" && ' GitChheckoutBranchMaster ' > "' TempFile '"', , "Hide"
    RunWait 'cmd.exe /c cd "' TargetFolder '" && ' GitCreateBranchSonar ' >> "' TempFile '"', , "Hide"
    RunWait 'cmd.exe /c cd "' TargetFolder '" && ' GitAddFile ' >> "' TempFile '"', , "Hide"
    RunWait 'cmd.exe /c cd "' TargetFolder '" && ' GitCommit ' >> "' TempFile '"', , "Hide"
    RunWait 'cmd.exe /c cd "' TargetFolder '" && ' GitPushOriginBranchSonar ' >> "' TempFile '"', , "Hide"
    RunWait 'cmd.exe /c cd "' TargetFolder '" && ' GitShowLog ' >> "' TempFile '"', , "Hide"

    ; Read the output from the file
    GitOutput := FileRead(TempFile)

    ; Clean up by deleting the temporary file
    FileDelete(TempFile)

    ; Display the output in a message box
    ; MsgBox(GitOutput)

    MsgBox "Apply sonarqube check done, gitoutput: " GitOutput, "Thong bao"
    ExitApp
}

