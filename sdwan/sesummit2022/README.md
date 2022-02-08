sp-aws-lab
------------
Scripts to spin up an AWS-based lab with traffic generation.


Logic:

1. Create template cloudgenix_config for '(1->N) - Branch'.
2. Spin up N ION images (from marketplace or private AMIs) in region. Use multi-use tokens and user-data, along with DHCP addresses for Internet and LAN.
2. Elastic IPs are likely required for each Internet Interface.
3. Wait for IONs to VFF and become machines in the tenant. Extract list of serials.
4. For each serial, use cloudgenix_config to configure each branch.
5. Wait for branches to come online.

