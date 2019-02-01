FROM alpine:latest

# Testing: pamtester
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator pamtester openssh && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Set up PKI infrastructure
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

# Prevents refused client connection due to an expired CRL
ENV EASYRSA_CRL_DAYS 3650

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# Add support for OTP authentication using a PAM module
ADD ./otp/openvpn /etc/pam.d/

# Copy sensitive configuration files
COPY ./conf/openvpn $OPENVPN
RUN chmod 0600 $EASYRSA_PKI/private/*
RUN chmod 0600 $EASYRSA_PKI/ta.key

# Configure SSH daemon
COPY ./conf/ssh/sshd_config /etc/ssh/sshd_config
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa > /dev/null
RUN ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa > /dev/null
RUN ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519 > /dev/null
