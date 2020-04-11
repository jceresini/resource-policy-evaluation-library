# Copyright 2019 The resource-policy-evaluation-library Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


package rpe.policy.dataproc_clusters_require_kerberos

#####
# Policy metadata
#####

description = "Require kerberos to ensure traffic between cluster nodes is encrypted"
applies_to = [
    "dataproc.googleapis.com/Cluster"
]

#####
# Resource metadata
#####

resource = input.resource
labels = resource.labels

#####
# Policy evaluation
#####

default valid = false
default excluded = false

valid = true {
  resource.config.securityConfig.kerberosConfig.enableKerberos == true
}

# Check for a global exclusion based on resource labels
excluded = true {
  data.exclusions.label_exclude(labels)
}

#####
# Remediation
#####

remediate = {
  "_remediation_spec": "v2beta1",
  "steps": [
    delete_dataproc_cluster
  ]
}

delete_dataproc_cluster = {
    "method": "delete",
    "params": {
        "projectId": resource.projectId,
        "region": labels["goog-dataproc-location"],
        "clusterName": resource.clusterName,
        "clusterUuid": resource.clusterUuid,
        "requestId": "real-time-enforcer-delete"
    }
}
