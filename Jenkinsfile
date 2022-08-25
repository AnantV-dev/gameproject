pipeline {
    agent any

    environment {
        registry = "shraddhal/tomcat_gaming"
	registryCredential = "docker_hub"
	AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
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
	  /*  
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
				bat """FOR /f "tokens=3 skip=1" %%i IN ('docker images --filter "reference =shraddhal/tomcat_gaming"') do docker rmi -f %%i"""
            }
        }
	  
	    
	   stage('Deploy') {//Terraform Provision and Configure
              steps {
			withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'access'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'secret')]) {
				bat '''cd terraform
				terraform init
				terraform plan
				terraform apply  -auto-approve'''	
			}
				
	      }
        }
	   */   stage('Terraform Destroy') {
		    input {
			message "Terraform Destroy"
			ok "Destroy"
		    }
		    steps {
			withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'access'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'secret')]) {
				bat '''cd terraform
				terraform destroy -auto-approve'''	
			}
		    }  
	    }
    }
}
