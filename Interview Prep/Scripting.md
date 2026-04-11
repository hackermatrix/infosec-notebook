
aws iam list-policies --scope Local --query 'Policies[*].Arn' --output text | while read policy  
do  
aws iam get-policy-version --policy-arn $policy --version-id v1 \  
| grep '"Action": "*"'  
done


aws ec2 describe-volumes \
  --query "Volumes[*].{ID:VolumeId,Encrypted:Encrypted}"

grep "authorization-mode" /etc/kubernetes/manifests/kube-apiserver.yaml
