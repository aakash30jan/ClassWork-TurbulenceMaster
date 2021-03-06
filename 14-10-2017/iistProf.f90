program TDMA
implicit doubleprecision(a-h,o-z)
parameter (nd = 100)
doubleprecision A(nd), B(nd), C(nd), D(nd), X(nd), P(0:nd), Q(0:nd)
c
A(1) = 0
C(n) = 0
c
c forward elimination
do i = 1, n
denom = B(i) + A(i)∗P(i−1)
P(i) = −C(i) /denom
Q(i) = (D(i) − A(i)∗Q(i−1)) /denom
enddo
c
c back substitution
do i = n, 1, −1
X(i) = P(i)∗X(i+1) + Q(i)
enddo
stop
end program
