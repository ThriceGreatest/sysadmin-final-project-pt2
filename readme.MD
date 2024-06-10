# Minecraft Server Setup Using Terraform

## Background

In this tutorial, we will automate the deployment of a Minecraft server on AWS using Terraform. Everything will be done from the command line, without accessing any of your AWS resources on the web aside from your credentials. We are running this server on US-East, but for different regions small changes could be made to `terraformvariables.tf`.

## Requirements

- AWS Account Ensure you have an active AWS account.
- AWS CLI Make sure AWS is installed in your shell [AWS CLI Installation Guide](httpsaws.amazon.comcli)
- Terraform Also make sure Terraform is installed in your shell [Terraform Installation Guide](httpswww.terraform.iodownloads.html)

## Initial Configuration

### 0. Clone the GitHub Repo

1. Clone this repo into the destination of your choice.
    ```bash
    git clone httpsgithub.comThriceGreatestminecraft_autoserver
2. We will assume many actions take place in the 'minecraft_autoserver' directory...

### 1. Set Up AWS Credentials

1. Open a terminal and navigate to your home directory

    ```bash
    cd ~
    ```

2. Create the `.aws` directory if it doesn't already exist

    ```bash
    mkdir -p .aws
    ```

3. Create a new file named `credentials.txt` using your preferred text editor (e.g., notepad.exe)

    ```bash
    notepad.exe credentials.txt
    ```

4. Paste in the credentials from your AWS Account. They should look something like

    ```
    [default]
    aws_access_key_id = YOUR_ACCESS_KEY_ID
    aws_secret_access_key = YOUR_SECRET_ACCESS_KEY
    region = YOUR_AWS_REGION
    ```

5. Save the file.

6. Make sure the file is named properly. If using notepad, it will save as a .txt by default. We can fix that with

    ```bash
    mv credentials.txt credentials
    ```
### 2. Edit the ~.awsconfig to ensure the region is set to us-east-1

1. Open the config file in editor of your choice    
    ```bash 
    notepad.exe config

8. Add this info
    ```
    [profile default]
    region = us-west-2
    ```
9. Save the file
10. Ensure its named correctl.y
    ```bash
    mv config.txt config

### 3. Create an AWS SSH Key Pair

1. Get back to the 'minecraft_autoserver' directory. Example

    ```bash
    cd ~/minecraft_autoserver
    ```

2. Generate a new key pair in that directory

    ```bash
    ssh-keygen -t rsa -b 2048 -f minecraft-key
    ```

3. Import that key pair into your AWS account

    ```bash
    aws ec2 import-key-pair --key-name minecraft-key --public-key-material fileb.minecraft-key.pub
    ```

### 4. Running the Script and Starting the Server

1. From the home 'minecraft_autoserver' directory, change to the 'terraform' directory

    ```bash
    cd terraform
    ```

2. Run the Terraform script

    ```bash
    terraform init
    terraform apply
    ```

### 5. Enter Necessary Info

1. After running the script it will ask for the key name. Enter `minecraft-key`.
2. When prompted again, enter `yes`.

### 6. Check Server Status and Connect to Server

1. After the long installation of Terraform is complete, you should see an IP output in the terminal. (If you don't, you can see it again with `terraform output`)

2. Using that IP, run the following command

    ```bash
    nmap -sV -Pn -p T25565 instance_public_ip
    ```

3. You should see some output like

    ```text
    Nmap scan report for ec2-18-233-65-83.compute-1.amazonaws.com (18.233.65.83)
    ```

4. Take that `...amazonaws.com` address and connect via the Minecraft direct connect option. Based on the above output we could connect via

    ```bash
    ec2-18-233-65-83.compute-1.amazonaws.com
    ```

## Conclusion

With the instructions followed up to this point, you should have a working Minecraft server on AWS that was automatically set up in a quick and easy manner. Enjoy your server.
