# Introduction 
The Shutter Page is designed to run as a static website hosted in an Azure storage container. 
The page is shown when any of the core Defra services are offline either for maintenance or because of an error. 

# Getting Started
To run and test the shutter page you will need:
1. Access to Azure devOps to run the **shutter-screen-static-website-upload** pipeline.
2. Run the pipeline using the following parameters:
   1. Branch - The main/feature branch you want to test. 
   2. Target environment to deploy - The environment to deploy to e.g. development, test, preprod, prod etc.
3. The pipeline will copy all files from within the Shutter Page directory including css/font files to the $web blob container on the **devrwdwebsa1401** storage container.
4. Once all files are copied you should be able to view the static website by navigating to  https://devrwdwebsa1401.z33.web.core.windows.net/.

# Contributing to this project
Please read the [contribution guidelines](CONTRIBUTING.md) before submitting a pull request.

# Licence
[Licence information](LICENCE.md).