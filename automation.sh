# name and S3  bucket info
name='ANUP'
s3_bucket="upgrad-anup"

# updating the ubuntu repo
apt update -y


# checking for the ubuntu installation
if [[ apache2 != $(dpkg --get-selections apache2 | awk '{print $1}') ]]; then
        apt install apache2
fi


# checking the status of ubuntu
active=$(systemctl status apache2 | grep active | awk '{print $2}')
if [[ active != ${active} ]]; then

        systemctl start apache2
fi


# checking the server enabled or not
enabled=$(systemctl is-enabled apache2 | grep "enabled" | awk '{print $1}')
if [[ enabled != ${enabled} ]]; then

        systemctl enable apache2
fi


# creating file_name as timestamp provided by upgrad
timestamp=$(date '+%d%m%Y-%H%M%S')



# creating tar or zip file
cd /var/log/apache2
tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log

# copying log files into my S3 bucket
aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar
