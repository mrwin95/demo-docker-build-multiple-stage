pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'NodeJS18.20.4'
    }
    environment {
        SCANNER_HOME = tool "SonarQubeScanner"
        APP_NAME = "demo-docker-sonar-pipeline"
        RELEASE="1.0.0"
        DOCKER_USER="mrwin95"
        DOCKER_PASS="Thang@123"
        IMAGE_NAME="${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }

    stages {
        stage('clean workspace') {
            steps {
                cleanWs()
            }
        }
        stage('checkout from git') {
            steps {
                git branch: 'main', url: 'https://github.com/mrwin95/demo-docker-build-multiple-stage.git'
            }
        }

        stage('Sonarqube Analyses') {
            steps {
                withSonarQubeEnv('SonarQube-Server'){
//                     sh '''$SCANNER_HOME/bin/sonar-scanner \
//                             -Dsonar.projectKey=Example-Sonarqube-CI \
//                             -Dsonar.sources=. \
//                             -Dsonar.host.url=http://13.114.235.148:9000 \
//                             -Dsonar.login=sqp_686fb0dbc833dd7accd86595899fdde445e2ca2a'''
                    sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Example-Sonarqube-CI \
                        -Dsonar.projectKey=Example-Sonarqube-CI \
                        -Dsonar.sources=.\
                        -Dsonar.language=java \
                        -Dsonar.java.libraries=**/target/classes'''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube-Token'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }

        stage('trivy fs scan') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
    }
}
