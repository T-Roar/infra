
pipeline {
    agent any

    environment {
        TF_VERSION = '0.15.4' // Set the desired Terraform version
    }

    stage('AWS Authentication') {
      steps {
        // Configure AWS credentials
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
          regionName: 'AWS_REGION'
        ]]) {
          sh 'aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID'
          sh 'aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY'
          sh 'aws configure set region $AWS_REGION'
        }
      }
    }

    stages {
        stage('Checkout') {
            steps{
                git 'https://github.com/T-Roar/infra.git'
            }
                
    }

    stage ('Install Terraform'){
        steps {
            // Install Terraform
            sh "curl -LO https://releases.hashicorp.com/terraform/${env.TF_VERSION}/terraform_${env.TF_VERSION}_linux_amd64.zip"
        sh "unzip terraform_${env.TF_VERSION}_linux_amd64.zip"
        sh "sudo mv terraform /usr/local/bin/"
        sh "rm terraform_${env.TF_VERSION}_linux_amd64.zip"
        }
    }

    stage('Terraform init'){
        steps {
        //Initialize Terraform
        sh 'terraform init'
        }
    }

    stage('Terraform Plan'){
        steps {
            // Run Terraform plan
            sh 'terraform plan'

        }
    }

    stage('Terraform Apply'){
        step {    // Run Terraform apply
        // You can use auto-approve -auto-approve if you want to skip interactive confirmation
        sh 'terraform apply -auto-approve'
        }
    
    }

  }

}