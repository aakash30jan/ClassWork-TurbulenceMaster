program main

use overloadAdd
implicit none
	type(space), dimension(3,3) :: A, B, C
	
	
	C=reshape( (/1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0/), (/ 3,3/))
	!Error: Can't convert REAL(4) to TYPE(space) at (1)
	B=reshape( (/1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0/), (/ 3,3/))
	!Error: Can't convert REAL(4) to TYPE(space) at (1)
	
	A=B + C
	
	print *, A

end program main
