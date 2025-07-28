# devops-case-study-2 - CI/CD Pipeline using Terraform, Ansible, Jenkins
## 📌 Project Overview

This project demonstrates a complete DevOps workflow that automates infrastructure provisioning, configuration management, application deployment, and CI/CD pipeline setup using the following tools:
- **Terraform** – for Infrastructure as Code (IaC)
- **Ansible** – for configuring EC2 instances and installing dependencies
- **Jenkins** – for automating the build and deployment pipeline
- **Git & GitHub** – for version control and source code repository
- **Docker** – for containerizing applications
- **AWS EC2** – as the cloud infrastructure

---

## 🔧 Tools & Technologies

| Tool      | Purpose                                 |
|-----------|------------------------------------------|
| Terraform | Provisioning AWS EC2 instance            |
| Ansible   | Installing Docker, configuring Jenkins   |
| Jenkins   | CI/CD automation pipeline                |
| Docker    | Running containerized application        |
| Git       | Version control                          |
| GitHub    | Remote code repository                   |
| AWS EC2   | Hosting Jenkins and application          |

---

## 📁 Repository Structure

devops-case-study-2
├── ansible/
│ ├── deploy.yml
│ ├── hosts.ini
│ 
├── infra/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ 
├──src/
│ ├── index.js
|
├── scripts/
│ └── build_and_push.sh
|
├── Dockerfile
|
|── Jenkinsfile
└── README.md

## 🚀 How to Run the Project


### Step 1: Clone the Repository
git clone https://github.com/dhaval-narale/devops-case-study-2.git
cd devops-case-study-2
cd "/mnt/c/Users/hp/OneDrive/Desktop/capg training/Case Study 2/devops-case-study-2" ( for wsl)
cd "C:\Users\hp\OneDrive\Desktop\capg training\Case Study 2\devops-case-study-2" (for cmd )

create a new branch 
git checkout -b develop

Protect the main Branch (on GitHub)
On GitHub:
Go to Settings → Branches → Branch protection rules
Click “Add rule”
Rule name: main
Enable:
 Require pull request reviews before merging
 Require status checks to pass (optional for now)
 Include administrators (optional)


### Step 2: Dockerization
1)	Create a basic src/ folder with index.js (Hello World)
2)	Create a Dockerfile:
	FROM bitnami/node:18
  WORKDIR /app
  COPY src/ .
  RUN npm init -y
	EXPOSE 3000
	CMD ["node", "index.js"]
	

3) Write scripts/build_and_push.sh:
4) Run the script locally:
	export GIT_COMMIT=$(git rev-parse --short HEAD)
./scripts/build_and_push.sh

This will push the image to dockerHub (dhavalnarale/devops-case-study:<commit>)

6)	Git add .
  Git commit -m “"Add Node.js app and Dockerfile"
  Git push origin develop
  And then go to github , you should see compare and pull request. Click on it and merge the changes
  This step should be repeated after each phase


### Step 3: Provision Infrastructure using Terraform
cd infra
terraform init
terraform plan
terraform apply
        This will create an EC2 instance and output its public IP.
        A custom VPC and public subnet
        A t2.micro EC2 running Ubuntu 22.04
        A Security Group allowing SSH (22) and HTTP (80)
        An Elastic IP: 13.234.233.59


### Step 4:Ansible Provisioning
create .gitignore file in our root folder (this will prevent generated files to be commited in git repo)
git add .gitignore
git push origin main
in project path, 
ansible-playbook -i ansible/hosts.ini ansible/deploy.yml


### Step 5:Set Up Jenkins
Access Jenkins via: http://<EC2_Public_IP>:8080
Unlock Jenkins and install suggested plugins
Create a new pipeline and use the Jenkinsfile from this repo


### Step 6: Push Code to GitHub
# PART 1: Configure Jenkins Pipeline to Track develop Branch
1.	Open Jenkins → Click your pipeline job (e.g., devops-case-study-pipeline)
2.	Click Configure
3.	Scroll down to the Pipeline section
4.	Under "Branch Specifier" (*/main by default), change it to:
*/develop
5.	✅ Under Build Triggers, check:
    GitHub hook trigger for GITScm polling
6.	Click Save


# PART 2: Set Up GitHub Webhook (for develop branch push events)
1.	Go to your GitHub repo:
    https://github.com/dhaval-narale/devops-case-study-2
2.	Click Settings (of the repo)
3.	From the left menu, click Webhooks → Click Add Webhook
4.	Fill in the form:
Field	Value
Payload URL	http://<your-jenkins-public-ip>:8080/github-webhook/
Content type	application/json
Secret	(leave empty if not configured in Jenkins)
Which events?	Just the push event
Active	Enabled
5.	Make sure Jenkins is accessible over the internet
(port 8080 must be open in EC2 security group)
6.	Click Add Webhook

 # PART 3: Test Webhook by Modifying index.js
Now let’s test the full flow. Follow these steps from your local machine:
1. Clone the repo if not already done
  git clone https://github.com/dhaval-narale/devops-case-study-2.git
  cd devops-case-study-2
2. Checkout the develop branch
  git checkout develop
3. Edit index.js and add your name

4. Commit and push

git add src/index.js
git commit -m "Add my name to index.js for webhook test"
git push origin develop



# PART 4: Verify Trigger in Jenkins
1.	Go to Jenkins → devops-case-study-pipeline
2.	Wait for 10–20 seconds
3.	It should trigger automatically 

Builds the Docker image
Pushes it to Docker Hub (if configured)
Deploys the container on the EC2 instance

# Part 5:
# Ensure you're on the develop branch
  git checkout develop
# Pull latest changes (if needed)
  git pull origin develop
# Switch to main branch
  git checkout main
# Merge develop into main
  git merge develop
# Push the updated main branch
  git push origin main


##  Branching Strategy
main: Stable production-ready code
develop: Active development branch


## Outcome
End-to-end CI/CD automated using Jenkins
EC2 and software stack provisioned automatically
Application deployed inside Docker containers
Git-based triggers for deployment

##  Author
Dhaval Narale
DevOps Enthusiast | Cloud Learner

