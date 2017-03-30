# Ansible provisioned performance testing system for Geogig.


## Requirements:

* Install Ansible 2.0.0 and boto with pip
  * `pip install ansible=2.0.0`
  * `pip install boto`

## Using the automated system:

**Fresh Test Run**

**Deploy AWS Instances :**  
  `ansible-playbook -i hosts deploy.yml`  
  (hosts should default to localhost)

**Provision the AWS instances :**  
  `./hosts/ec2.py --refresh-cache`
  `ansible-playbook -i hosts/ install.yml`
  
**Provision specific instances/roles :**  
 `ansible-playbook -i hosts/ install.yml --limit tag_type_gig_qa_geoserver`

**Terminate Instances**