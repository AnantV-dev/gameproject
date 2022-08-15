pipeline {
    agent any

    environment {
        registry = "shraddhal/tomcat_gaming"
	registryCredential = "docker_hub"
    }
	
    stages {
        stage('Clone') {
			 steps {	       
				git 'https://github.com/shraddhaL/jenkinspipeline.git'
			   }
		 }
		 
	stage('Build') {
			 steps {
				bat  'cd target &  del gaming.war & cd ..' 
				bat 'mvn clean package'
			   }
		 } 
	    
	stage('Dockerization') {
			 steps {
				script{
					app = docker.build(registry)
				
					docker.withRegistry('', registryCredential ) 
					 {
						app.push("${BUILD_ID}")
						app.push("latest")
					 }
				}
				 
				
				bat 'docker run -d --name mytomcat -p 9090:8080 shraddhal/tomcat_gaming:latest'
			   }
		 }
	 stage('Docker Cleanup') {
              steps {
                		bat 'docker stop mytomcat'
				bat 'docker rm mytomcat'
				bat 'docker rmi $(docker images shraddhal/tomcat_gaming)'
            }
        }
	    
    }
}
