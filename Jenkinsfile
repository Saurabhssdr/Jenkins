pipeline {
    agent any
 
    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/Saurabhssdr/Jenkins'
            }
        }
 
        stage('List Files After Clone') {
            steps {
                sh 'ls -la'
            }
        }
 
        // stage('Terraform Init') {
        //     steps {
        //         sh 'terraform init'
        //     }
        // }
 
        // stage('Terraform Plan') {
        //     steps {
        //         sh 'terraform plan -out=tfplan'
        //     }
        // }
 
        stage('Terraform destroy') {
            steps {
                sh 'terraform destroy -auto-approve tfplan'
            }
        }
    }
}
 
 