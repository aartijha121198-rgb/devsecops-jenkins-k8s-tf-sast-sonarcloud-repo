pipeline {
  agent { label 'agent-1' }

  environment {
    AWS_REGION = "us-west-1"
  }

  stages {

    stage('Sonar') {
      steps {
        sh '''
        mvn clean verify sonar:sonar \
        -Dsonar.projectKey=asgbuggywebapp \
        -Dsonar.organization=asgbuggywebapp \
        -Dsonar.host.url=https://sonarcloud.io \
        -Dsonar.token=94d0217a5309dac0adc2fd40621c9858cf495261
        '''
      }
    }

    stage('Snyk') {
      steps {
        withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
          script {
            def status = sh(script: 'mvn snyk:test', returnStatus: true)
            if (status != 0) {
              echo "Snyk found vulnerabilities ⚠️"
              currentBuild.result = 'UNSTABLE'
            }
          }
        }
      }
    }

    stage('Build & Push') {
      steps {
        script {
          def app = docker.build("asg-agent1")
          docker.withRegistry('https://004070549669.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:aws-credentials') {
            app.push("latest")
          }
        }
      }
    }

  }
}
