# Jenkins

- **See also:**
  - Learning
    - [Syntax reference](https://www.jenkins.io/doc/book/pipeline/syntax/)
    - [Global variable reference](https://ci.eclipse.org/tracecompass/job/tracecompass-incubator-sonar/pipeline-syntax/globals)
    - [Jenkins handbook](https://www.jenkins.io/doc/book/getting-started/)
  - Installation
    - [Helm chart](https://artifacthub.io/packages/helm/jenkinsci/jenkins)

## Generic example

```groovy
// Jenkins Declarative Pipeline syntax reference:
// https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline

pipeline {

    // agent directive:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#agent
    agent any

    // options directive:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#options
    options {
        // buildDiscarder option using LogRotator:
        // https://www.jenkins.io/doc/book/pipeline/syntax/#options
        // https://javadoc.jenkins.io/hudson/tasks/LogRotator.html
        buildDiscarder(logRotator(numToKeepStr: '20', artifactNumToKeepStr: '20'))

        // disableConcurrentBuilds option:
        // https://www.jenkins.io/doc/book/pipeline/syntax/#options
        disableConcurrentBuilds()

        // timestamps step (Timestamper plugin):
        // https://www.jenkins.io/doc/pipeline/steps/timestamper/#timestamps-timestamps
        timestamps()

        // timeout wrapper at pipeline level:
        // Declarative options:
        //   https://www.jenkins.io/doc/book/pipeline/syntax/#options
        // Step reference:
        //   https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#timeout-enforce-time-limit
        timeout(time: 60, unit: 'MINUTES')
    }

    // triggers directive:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#triggers
    // Cron & pollSCM behavior:
    // https://docs.cloudbees.com/docs/cloudbees-ci/latest/pipeline-syntax-reference-guide/declarative-pipeline#_triggers
    triggers {
        cron('H H * * 1-5')        // Run once on weekdays
        pollSCM('H/5 * * * *')     // Poll SCM every 5 minutes
    }

    // parameters directive:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#parameters
    parameters {
        // string parameter:
        // https://www.jenkins.io/doc/book/pipeline/syntax/#parameters
        string(
            name: 'APP_ENV',
            defaultValue: 'dev',
            description: 'Application environment (dev/stage/prod)'
        )

        // booleanParam:
        // https://www.jenkins.io/doc/book/pipeline/syntax/#parameters
        booleanParam(
            name: 'RUN_INTEGRATION_TESTS',
            defaultValue: false,
            description: 'Run integration tests?'
        )

        // choice parameter:
        // https://www.jenkins.io/doc/book/pipeline/syntax/#parameters
        choice(
            name: 'DEPLOY_TARGET',
            choices: ['none', 'staging', 'production'],
            description: 'Where to deploy'
        )
    }

    // environment directive:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#environment
    // credentials() helper:
    // https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#for-secret-text-usernames-and-passwords-and-secret-files
    environment {
        APP_NAME = 'example-service'
        APP_PORT = '8080'

        // Provides env vars based on the credential type
        GIT_CREDENTIALS = credentials('github-ssh-key-id')
    }

    // tools directive:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#tools
    tools {
        maven 'maven-3.9'
        jdk   'jdk-17'
    }

    // stages directive:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#stages
    stages {

        // stage directive:
        // https://www.jenkins.io/doc/book/pipeline/syntax/#stage
        stage('Initialize') {

            // when directive:
            // https://www.jenkins.io/doc/book/pipeline/syntax/#when
            when {
                anyOf {
                    environment name: 'APP_ENV', value: 'dev'
                    branch 'main'
                }
            }

            // steps directive:
            // https://www.jenkins.io/doc/book/pipeline/syntax/#steps
            steps {
                // echo step:
                // https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#echo-print-message
                echo "Initializing pipeline for ${env.APP_NAME} in ${params.APP_ENV}"

                // cleanWs step (Workspace Cleanup plugin):
                // https://www.jenkins.io/doc/pipeline/steps/ws-cleanup/#cleanws-delete-workspace-when-build-is-done
                cleanWs()

                // checkout step using the job’s SCM configuration:
                // https://www.jenkins.io/doc/pipeline/steps/workflow-scm-step/#checkout-check-out-from-version-control
                checkout scm
            }
        }

        stage('Build') {
            // agent at stage level:
            // https://www.jenkins.io/doc/book/pipeline/syntax/#agent
            agent {
                label 'linux-build'
            }

            steps {
                // sh step:
                // https://www.jenkins.io/doc/pipeline/steps/workflow-durable-task-step/#sh-shell-script
                sh '''
                    set -e
                    ./gradlew clean assemble
                '''

                // stash built artifacts:
                // https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#stash-stash-some-files-to-be-used-later-in-the-build
                stash name: 'build-artifacts', includes: 'build/libs/**/*.jar'
            }
        }

        stage('Unit tests') {
            steps {
                // timeout step:
                // https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#timeout-enforce-time-limit
                timeout(time: 15, unit: 'MINUTES') {
                    sh './gradlew test'
                }

                // junit step:
                // https://www.jenkins.io/doc/pipeline/steps/junit/#junit-archive-junit-formatted-test-results
                junit testResults: 'build/test-results/test/*.xml', allowEmptyResults: true
            }
        }

        stage('Static analysis') {
            when {
                // when / expression:
                // https://www.jenkins.io/doc/book/pipeline/syntax/#when
                expression { env.BRANCH_NAME == 'main' }
            }
            steps {
                sh './gradlew check'
            }
        }

        stage('Integration tests') {
            when {
                expression { return params.RUN_INTEGRATION_TESTS }
            }

            // parallel directive:
            // https://www.jenkins.io/doc/book/pipeline/syntax/#parallel
            parallel {
                stage('Integration tests DB') {
                    steps {
                        // unstash step:
                        // https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#unstash-restore-files-previously-stashed
                        unstash 'build-artifacts'
                        sh './gradlew integrationTestDb'
                    }
                }

                stage('Integration tests API') {
                    steps {
                        unstash 'build-artifacts'
                        sh './gradlew integrationTestApi'
                    }
                }
            }
        }

        stage('Package') {
            steps {
                // script directive inside Declarative:
                // https://www.jenkins.io/doc/book/pipeline/syntax/#script
                script {
                    // fileExists step:
                    // https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#fileexists-verify-if-file-exists-in-workspace
                    if (!fileExists('build/libs')) {
                        // error step:
                        // https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#error-error-signal
                        error "Expected build/libs directory not found"
                    }
                }

                // archiveArtifacts step:
                // https://www.jenkins.io/doc/pipeline/steps/core/#archiveartifacts-archive-the-artifacts
                archiveArtifacts artifacts: 'build/libs/**/*.jar', fingerprint: true

                // stash packaged artifacts for later deploy:
                // https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#stash-stash-some-files-to-be-used-later-in-the-build
                stash name: 'package', includes: 'build/libs/**/*.jar'
            }
        }

        stage('Manual approval') {
            when {
                anyOf {
                    environment name: 'APP_ENV', value: 'prod'
                    equals expected: 'production', actual: params.DEPLOY_TARGET
                }
            }

            steps {
                // input step (Pipeline: Input Step plugin):
                // https://www.jenkins.io/doc/pipeline/steps/pipeline-input-step/#input-wait-for-interactive-input
                input message: "Deploy ${env.APP_NAME} to ${params.DEPLOY_TARGET}?", ok: 'Deploy'
            }
        }

        stage('Deploy') {
            when {
                expression { params.DEPLOY_TARGET != 'none' }
            }

            // environment at stage scope:
            // https://www.jenkins.io/doc/book/pipeline/syntax/#environment
            environment {
                TARGET_ENV = "${params.DEPLOY_TARGET}"
            }

            steps {
                // withCredentials step (Credentials Binding plugin):
                // https://www.jenkins.io/doc/pipeline/steps/credentials-binding/#withcredentials-bind-credentials-to-variables
                withCredentials([
                    usernamePassword(
                        credentialsId: 'deployment-user',
                        usernameVariable: 'DEPLOY_USER',
                        passwordVariable: 'DEPLOY_PASS'
                    )
                ]) {

                    // script directive:
                    // https://www.jenkins.io/doc/book/pipeline/syntax/#script
                    script {
                        echo "Deploying to ${TARGET_ENV} as ${DEPLOY_USER}"
                    }

                    unstash 'package'

                    // retry step:
                    // https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#retry-retry-the-body-up-to-n-times
                    retry(3) {
                        sh '''
                            set -e
                            ./scripts/deploy.sh \
                              --env "${TARGET_ENV}" \
                              --user "${DEPLOY_USER}" \
                              --password "${DEPLOY_PASS}"
                        '''
                    }
                }
            }
        }
    }

    // post directive:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#post
    // Tour of post usage:
    // https://www.jenkins.io/doc/pipeline/tour/post/
    post {
        always {
            echo 'Post: always'
            cleanWs()
        }

        success {
            echo 'Post: success'
        }

        failure {
            echo 'Post: failure'
        }

        unstable {
            echo 'Post: unstable'
        }

        changed {
            echo "Post: build result changed from previous: ${currentBuild.previousBuild?.result} -> ${currentBuild.currentResult}"
        }
    }
}
```
