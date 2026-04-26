pipeline {
  agent none

  environment {
    AWS_REGION = "us-west-1"
    CLUSTER_NAME = "my-eks-cluster"
  }

  stages {

    stage('CI on Both Agents') {
      parallel {

        // =========================
        // Agent-1
        // =========================
        stage('Agent-1 CI') {
          agent { label 'agent-1' }

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

        // =========================
        // Agent-2
        // =========================
        stage('Agent-2 CI') {
          agent { label 'agent-2' }

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
                  def app = docker.build("asg-agent2")
                  docker.withRegistry('https://004070549669.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:aws-credentials') {
                    app.push("latest")
                  }
                }
              }
            }
          }
        }

      }
    }

    // =========================
    // EKS Provision ONLY on Agent-1
    // =========================
    stage('EKS Provision & Deploy (Agent-1)') {
      agent { label 'agent-1' }

      stages {

        stage('Provision EKS') {
          steps {
            sh '''
            cd eks-terraform
            terraform init
            terraform apply -auto-approve
            '''
          }
        }

        stage('Update kubeconfig') {
          steps {
            sh '''
            aws eks update-kubeconfig \
              --region $AWS_REGION \
              --name $CLUSTER_NAME
            '''
          }
        }

        stage('Deploy App') {
          steps {
            sh '''
            kubectl apply -f k8s/deployment.yaml
            kubectl apply -f k8s/service.yaml
            '''
          }
        }
      }
    }

  }
}
