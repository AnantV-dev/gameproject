pipeline {
    agent any

    environment {
        registry = "shraddhal/tomcat_gaming"
	registryCredential = "docker_hub"
	AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
	uuidver = UUID.randomUUID().toString()
    }
	
    stages {
        stage('Clone') {
			 steps {	       
				git 'https://github.com/shraddhaL/jenkinspipeline.git'
			   }
		 }
	    
	stage('UUID gen') {
	    steps {
		    bat 'echo %uuidver% > src/main/webapp/version.html'
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
				
				
			   }
		 }
		
		stage('Docker Tomcat server') {
			      steps {
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
	    
	    */
	   stage('Deploy') {//Terraform Provision and Configure
              steps {
			withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'access'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'secret')]) {
				bat '''cd terraform
				terraform init
				terraform plan -out tfplan
				terraform apply  -auto-approve'''	
			}
				
	      }
        }
	    
	     stage('Acceptance Test') {
		      steps {
			    bat '''cd terraform
			    FOR /F "tokens=*" %%a in ('terraform output -raw public_dns') do SET url=%%a
			    curl -s -o /dev/null -w "%%{http_code}" %%url%%:8080/gaming/game.html
			    FOR /F "tokens=*" %%a in ('curl %url%:8080/gaming/version.html') do SET version=%%a
			    if %uuidver%==%version% (echo "Latest version") else (echo "Older version")'''
		      }
	     }
	     
    }
	
	post{
		always{
				input(message: "Terraform Destroy", ok: "Destroy")
			 withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'access'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'secret')]) {
				bat '''cd terraform
				terraform destroy -auto-approve'''	
			}
		}
	}
}
