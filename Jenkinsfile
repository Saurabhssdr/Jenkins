pipeline {
    agent any
 
    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'saurabh', url: 'https://github.com/Saurabhssdr/Jenkins.git'
            }
        }
 
        stage('List Files After Clone') {
            steps {
                sh 'ls -la'
            }
        }
 
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
 
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
 
        stage('Terraform apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
 
 