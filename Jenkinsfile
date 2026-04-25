pipeline {
  agent any
  tools { 
        maven 'Maven_3_8_4'  
    }
   stages{
    stage('CompileandRunSonarAnalysis') {
            steps {	
		sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=aj-javabuggywebapp01 -Dsonar.organization=AJ_JavaBuggyWebapp01 -Dsonar.host.url=https://sonarcloud.io -Dsonar.token=94d0217a5309dac0adc2fd40621c9858cf495261'
			}
        } 
  }
}
