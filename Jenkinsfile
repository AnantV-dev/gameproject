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
				 bat 'del target\gaming.war'
              		   bat  'del /f target\gaming' 
				bat 'mvn clean package'
			   }
		 } 
	    
	stage('Dockerization') {
			 steps {
				script{
					app = docker.build(registry)
				
					docker.withRegistry('https://registry.hub.docker.com', registryCredential ) 
					 {
						app.push("${BUILD_ID}")
					 }
				}
			   }
		 }	 
	    
    }
}
