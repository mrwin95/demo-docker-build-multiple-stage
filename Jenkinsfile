pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'NodeJS18.20.4'
    }
    environment {
        SCANNER_HOME = tool "sonar-scanner"
        APP_NAME = ""
        RELEASE=""
        DOCKER_USER="mrwin95"
        DOCKER_PASS="Thang@123"
        IMAGE_NAME="${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
//         JENKINS_API_TOKEN=credentials("JENKINS_API_TOKEN")
    }

    stages {
        stage("clean workspace") {
            steps {
                cleanws()
            }
        }
        stage("checkout from git") {
                    steps {
                        git branch: 'main', url:
                    }
                }
    }
}
