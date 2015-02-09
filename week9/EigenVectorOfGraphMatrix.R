# EigenVectorOfGraphMatrix.R

#Clear Workspace
rm(list=ls())
# Clear Console:
cat("\014")

nodeNames <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J")
#      A  B  C  D  E  F  G  H  I  J
A <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
B <- c(1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
C <- c(0, 1, 0, 0, 0, 0, 0, 0, 0, 0)
D <- c(0, 0, 1, 0, 0, 0, 1, 1, 0, 0) #        A  B  C  D  E  F  G  H  I  J
E <- c(0, 0, 0, 1, 0, 0, 0, 1, 0, 0) # E <- c(0, 0, 0, 1, 1, 0, 0, 1, 0, 0)
F <- c(0, 1, 1, 0, 0, 0, 0, 0, 0, 0)
G <- c(0, 0, 1, 0, 0, 0, 0, 0, 0, 0)
H <- c(0, 0, 0, 0, 0, 0, 0, 0, 1, 0)
I <- c(0, 0, 0, 1, 0, 0, 0, 0, 0, 1)
J <- c(0, 0, 0, 0, 0, 0, 0, 0, 1, 0)
initialMatrix = matrix(c(A, B, C, D, E, F, G, H, I, J), ncol=10, byrow=TRUE) # + 0.01
colnames(initialMatrix) <- nodeNames
rownames(initialMatrix) <- nodeNames
initialMatrix

outDegree <- colSums(initialMatrix)
outDegree

inDegree <- rowSums(initialMatrix)
inDegree

outDegreeMatrix <- matrix(rep(outDegree, times=10), nrow=10, ncol=10, byrow=TRUE)
adjustedMatrix <- initialMatrix / outDegreeMatrix
adjustedMatrix[is.na(adjustedMatrix)] <- 0
round(adjustedMatrix, 1)

inDegree <- rowSums(adjustedMatrix)
round(inDegree, 1)

#possibility of getting to page with noise
adjustedMatrix <- adjustedMatrix + 0.01 # 0.00
adjustedMatrix

importance <- inDegree # matrix(c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1), ncol=1)
print(round(t(importance), 3))

importance <- adjustedMatrix %*% importance
importance <- importance/sum(importance)
print(round(t(importance), 3))
importance <- adjustedMatrix %*% importance
importance <- importance/sum(importance)
print(round(t(importance), 3))
importance <- adjustedMatrix %*% importance
importance <- importance/sum(importance)
print(round(t(importance), 3))

importance <- inDegree # matrix(c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1), ncol=1)
for (iter in 1:1000)
{
  importance <- adjustedMatrix %*% importance
  importance <- importance/sum(importance)
}

print(round(t(importance), 3))

eigenVectors <- eigen(adjustedMatrix)$vector
eigenVector <- eigenVectors[, 1]
names(eigenVector) <- nodeNames
round(Re(eigenVector/sum(eigenVector)),3)
