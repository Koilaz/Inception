#!/bin/sh
set -e

# Get FTP password
FTP_PASSWORD=$(cat /run/secrets/ftp_password)

# Create user if missing (Alpine uses adduser instead of useradd)
if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser -h /var/www/html -s /bin/sh -D "$FTP_USER"
fi
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
chown -R "$FTP_USER:$FTP_USER" /var/www/html

# Generate self-signed TLS certificate
mkdir -p /etc/ssl/private
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/vsftpd.key \
    -out /etc/ssl/private/vsftpd.crt \
    -subj "/C=FR/ST=AL/L=MULHOUSE/O=42/CN=${DOMAIN_NAME}" >/dev/null 2>&1

# Start vsftpd in foreground
exec vsftpd /etc/vsftpd/vsftpd.conf
