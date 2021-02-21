pipeline {
    agent {node 'ubuntu-worker-2') {
        stages {
            stage("Checkout from SCM") {
                steps {
                    checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/TomKugelman/Terraform-jenkins-kubernetes-flask']]])
                }
            } 
            stage("Start Cluster") {
                catchError(buildResult: 'SUCCESS') {
                    steps {
                        sh 'kind create cluster'
                    }
                }
            }
            stage("Create Kubernetes Deployment and Service") {
                steps {
                    sh 'terraform init'
                    sh 'terraform apply'
                }
            }
        }
    }
}