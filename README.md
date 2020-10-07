TF Version: https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip

Helpful info: https://jebpages.com/2019/02/25/installing-kubeadm-on-fedora-coreos/

```bash
# find CentOS ami ids
aws ec2 describe-images \
      --owners aws-marketplace \
      --filters Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce \
      --query 'Images[*].[CreationDate,Name,ImageId]' \
      --filters "Name=name,Values=CentOS Linux 7*" \
      --region us-west-2 \
      --output table \
  | sort -r
```

```
cat infra-tf/terraform.tfstate | jq '.resources[] | select(.type == "aws_instance") | {name: .name, ip: .instances[0].attributes.public_ip}'
```

```
cd
yum update -y
reboot
yum install -y  podman gcc git containers-common   device-mapper-devel   git   glib2-devel   glibc-devel   glibc-static   runc
git clone https://github.com/cri-o/cri-o.git
curl https://dl.google.com/go/go1.12.14.linux-amd64.tar.gz -o go.tar.gz
tar -C /usr/local -xzf go.tar.gz
export PATH=$PATH:/usr/local/go/bin
cd cri-o/
make
make release-bundle
```

To cross-build cri-o binary in a CentOS container, build the Dockerfile for cri-o, then run:

```
podman run --rm -e CGO_ENABLED=1 -v "$(PWD)":/go/src/github.com/cri-o/cri-o:Z -w /go/src/github.com/cri-o/cri-o localhost/crio-bin make binaries
```
