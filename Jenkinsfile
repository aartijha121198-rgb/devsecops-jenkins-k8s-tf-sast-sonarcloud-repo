pipeline {
  agent any
  tools { 
        maven 'Maven_3_8_4'  
    }
   stages{
    stage('CompileandRunSonarAnalysis') {
            steps {	
		sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=asgbuggywebapp000 -Dsonar.organization=asgbuggywebapp000 -Dsonar.host.url=https://sonarcloud.io -Dsonar.token=94d0217a5309dac0adc2fd40621c9858cf495261'
			}
    }

	stage('RunSCAAnalysisUsingSnyk') {
            steps {		
				withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
					sh 'mvn snyk:test -fn'
				}
			}
    }

	stage('Build') { 
            steps { 
               withDockerRegistry([credentialsId: "dockerlogin", url: ""]) {
                 script{
                 app =  docker.build("jenkins-app-repo")
                 }
               }
            }
    }

	stage('Push') {
            steps {
                script{
                    docker.withRegistry('https://004070549669.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:aws-credentials') {
                    app.push("latest")
                    }
                }
            }
    	}
	    
  }
}
