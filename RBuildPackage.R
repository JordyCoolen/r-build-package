#   Copyright 2013 Jordy Coolen
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

require (inlinedocs)

new.pckge <- function 
### Function create a new R package
(Rscript, ##<< Input of Rscript
 pckge, ##<< Give package name
 setwork = getwd() ##<< Set path of working directory where Input Rscript is present and package folder will be made
){
  
  ##setting working directory
  setwd(setwork)
  
  ## Run this once to create package skeleton
  ## After running, edit DESCRIPTION and NAMESPACE
  package.skeleton(name = pckge, code_files = Rscript)  
  
  ### Output is a new installed package
}


update.pckge <- function
### Function to update a existing R packages
(Rscript, ##<< Input of Rscript
 pckge, ##<< Give package name
 setwork = getwd() ##<< Set path of working directory where Input Rscript is present and package folder is present
){
  
  ##setting working directory
  setwd(setwork)
  
  ## Run this each time you want to rebuild the package (after code changes)
  dir.create(paste(pckge,"/R", sep=""), showWarnings = F)
  dir.create(paste(pckge,"/man", sep=""), showWarnings = F)
  file.copy(Rscript, paste(pckge, "/R/", Rscript, sep=""), overwrite = T)
  package.skeleton.dx(pckge)
  system(paste("R CMD build ",pckge, sep=""))
  
  ### Output is a installed and Updated packages
}

install.pckge <- function
### package to update a existing R packages
(pckge, ##<< Give package name
 setwork = getwd(), ##<< Set path of working directory where updated package is present
 lib="/usr/local/lib/R/site-library" ##<< Location for package install
){
  
  ##setting working directory
  setwd(setwork)
  
  ## Run this to install the package
  files = list.files(getwd(), paste0(pckge, ".+\\.tar.gz"))
  latest = sort(files, decreasing=T)[1]
  install.packages(latest, lib = lib, repo=NULL, dependencies=T)
  
  if(paste0("package:", pckge) %in% search()) {
    detach(paste0("package:", pckge), unload=T, character.only=T)
    library(pckge, character.only=T)
  }
  
  ### Installs package  
}

updateinstall.pckge <- function
### Package to update and install existing R packages
(Rscript, ##<< Input of Rscript
 pckge, ##<< Give package name
 setwork = getwd() ##<< Set path of working directory where Input Rscript is present and package folder will be made
){
  ## Updates the package
  update.pckge(Rscript, pckge, setwork)
  
  ## Run this to install the package
  install.pckge(pckge, setwork)
  
  ### Installs, updates and reloads package if it was loaded already 
}
