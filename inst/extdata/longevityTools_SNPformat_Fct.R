
#compare chr and position between Illumina Manifest H and Rayner
posCmp <- function(posA,posB,chrA,chrB){
  posDisagree<-ifelse(posA!=posB,1,0)
  chrA[chrA=="XY"]<-"X"
  chrB[chrB=="XY"]<-"X"
  chrDisagree<-ifelse(chrA!=chrB,1,0)
  
  return(cbind(chrDisagree,posDisagree))
}

