pipeline {
    agent any
	tools {
		maven 'Maven-3.5.3'
		jdk 'JDK1.8.0'
        //sonar-scanner 'sonar-scanner-3.2.0'
	}
	
	environment {
        DOCKER_HOST="docker.io/deepan10" 
	}

    stages {
        stage ('Build & Test') {
        	steps {				
				sh 'mvn clean install'
            }
            post {
				success {
					junit testResults: 'target/surefire-reports/**/*.xml', allowEmptyResults: true
				}
			}
        }
		stage ('SonarAnalysis') {
			steps {
                withSonarQubeEnv('sonarcloud') {                    
                    sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'
                }
			}			
		}		
		/*stage ('Docker Build') {
			steps{                
				    sh 'docker build . --build-arg JARFILE=myprofile-0.0.1.jar -t myprofile-app'                
			}
		}
		stage ('DockerHub Deploy') {
        	steps {
                withDockerRegistry([credentialsId: 'something']) {
                    sh 'docker tag myprofile-app deepan10/profile:App-${BUILD_NUMBER}'
                    sh 'docker push deepan10/profile:App-${BUILD_NUMBER}'
                }        		
			}
		}*/       
    }	
}
