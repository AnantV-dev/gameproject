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
				bat 'rm target/gaming.war'
                bat  'rm -rf target/gaming.war' 
				bat 'mvn clean package'
			   }
		 }
		 
    }
}
