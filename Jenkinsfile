pipeline {
    agent any

    stages {
        stage('Clone') {
			 steps {	       
				git 'https://github.com/shraddhaL/jenkinspipeline.git'
			   }
		 }
		 
		 stage('Build') {
			 steps {	       
				bat 'mvn clean package'
			   }
		 }
		 
    }
}
