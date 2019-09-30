# Editable Dockerfiles for building AWS CLI and Nexus OSS Repository Images

### Dockerfiles

#### *AWSCLI*

Containerized AWS CLI on alpine to avoid requiring the aws cli to be installed on CI machines.

**Entrypoint:** "aws"

#### *Sonatype Nexus*

A container image for Sonatype Nexus Repository Manager OSS, based on Alpine Linux. Environment variables (e.g., Nexus version, etc) can be changed according to the requirements.