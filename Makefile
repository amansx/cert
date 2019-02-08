certs-dir=$(shell pwd)/certs
template-dir=$(shell pwd)/csr-templates

init:
	go get -u github.com/cloudflare/cfssl/cmd/...
	mkdir -p $(template-dir)
	mkdir -p $(template-dir)
	cfssl print-defaults csr > $(template-dir)/ca-csr.json
	cfssl print-defaults config > $(template-dir)/ca-config.json
ca:
	cd $(certs-dir) && cfssl genkey -initca $(template-dir)/ca-csr.json | cfssljson -bare ca
cert:
	cd $(certs-dir) && \
	cfssl gencert -ca=$(certs-dir)/ca.pem -ca-key=$(certs-dir)/ca-key.pem -config=$(template-dir)/ca-config.json \
	-profile=www -hostname=$(host) $(template-dir)/ca-config.json | cfssljson -bare server
	cfssl-certinfo -cert certs/server.pem