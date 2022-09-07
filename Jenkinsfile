pipeline {
    agent any

    environment {
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
