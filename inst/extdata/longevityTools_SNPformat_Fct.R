
#compare chr and position between Illumina Manifest H and Rayner
posCmp <- function(posA,posB,chrA,chrB){
  posDisagree<-ifelse(posA!=posB,1,0)
  chrA[chrA=="XY"]<-"X"
  chrB[chrB=="XY"]<-"X"
  chrDisagree<-ifelse(chrA!=chrB,1,0)
  
  return(cbind(chrDisagree,posDisagree))
}

#compare Illumina's manifest H alleles with Rayner's
strandCheck <- function(A1,B1,A2,B2,strand){
  #A1 = A allele of study
  #B1 = B allele of study
  #A2 = A allele of Rayner
  #B2 = B allele of Rayner
  A1<-toupper(A1)
  B1<-toupper(B1)
  A2<-toupper(A2)
  B2<-toupper(B2)
  #ensure A2 is lower alphabet value that B2 for rayner alleles
  if ( sum(A2>B2) > 0 ) print(paste0("There are ", sum(A2>B2), " SNPs with Rayner allele A > B"))
  else print("Rayner alleles A < B for all SNPs")
  
  #order A1 and B1 alleles so A1 is the lowest alphabet value
  if ( sum(A1>B1) > 0 ) print(paste0("There are ", sum(A1>B1), " SNPs with Beth allele A > B"))
  else print("Beth alleles A < B for all SNPs")
  tempA<-A1
  tempA[A1>B1]<-B1[A1>B1]
  tempB<-B1
  tempB[A1>B1]<-A1[A1>B1]
  A1<-tempA
  B1<-tempB
  
  #flip rayner alleles if strand is -
  tempA<-A2
  tempB<-B2
  tempA[strand=="-" & A2=="G"]<-"C"
  tempA[strand=="-" & A2=="C"]<-"G"
  tempA[strand=="-" & A2=="A"]<-"T"
  tempA[strand=="-" & A2=="T"]<-"A"
  tempB[strand=="-" & B2=="G"]<-"C"
  tempB[strand=="-" & B2=="C"]<-"G"
  tempB[strand=="-" & B2=="A"]<-"T"
  tempB[strand=="-" & B2=="T"]<-"A"
  A2<-tempA
  B2<-tempB
  #after flip, must reorder so lowest alphabet value listed first
  A2[tempA>tempB]<-tempB[tempA>tempB]
  B2[tempA>tempB]<-tempA[tempA>tempB]
  
  #test for same alleles 
  noMatch<-rep(0,length(A1))
  noMatch[A1!=A2 | B1!=B2]<-1
  
  #Are the no match SNPs flipped?
  #After flipping strands of A1 and A2, do they match Rayner?
  tempA<-A1
  tempB<-B1
  tempA[noMatch==1 & A1=="G"]<-"C"
  tempA[noMatch==1 & A1=="C"]<-"G"
  tempA[noMatch==1 & A1=="A"]<-"T"
  tempA[noMatch==1 & A1=="T"]<-"A"
  tempB[noMatch==1 & B1=="G"]<-"C"
  tempB[noMatch==1 & B1=="C"]<-"G"
  tempB[noMatch==1 & B1=="A"]<-"T"
  tempB[noMatch==1 & B1=="T"]<-"A"
  A1<-tempA
  B1<-tempB
  #after flip, must reorder so lowest alphabet value listed first
  A1[tempA>tempB]<-tempB[tempA>tempB]
  B1[tempA>tempB]<-tempA[tempA>tempB]
  
  #test for same alleles
  flipped<-rep(0,length(A1))
  flipped[A1==A2 & B1==B2 & noMatch==1]<-1
  
  return(cbind(noMatch,flipped))
  
}


#flip the strands of the flipped SNPs
strandFlip<-function(A1,B1,flip){
  #A1 = A allele of study
  #B1 = B allele of study
  A1<-toupper(A1)
  B1<-toupper(B1)
  tempA<-A1
  tempB<-B1
  tempA[flip==1 & A1=="G"]<-"C"
  tempA[flip==1 & A1=="C"]<-"G"
  tempA[flip==1 & A1=="A"]<-"T"
  tempA[flip==1 & A1=="T"]<-"A"
  tempB[flip==1 & B1=="G"]<-"C"
  tempB[flip==1 & B1=="C"]<-"G"
  tempB[flip==1 & B1=="A"]<-"T"
  tempB[flip==1 & B1=="T"]<-"A"
  A1<-tempA
  B1<-tempB
  return(cbind(A1,B1))
}
