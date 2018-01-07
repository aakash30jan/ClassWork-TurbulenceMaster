Module calc_subroutine
	implicit none
	
	contains
	 !this subroutine solve the linear system of equations by using JACOBI METHOD
		subroutine jacobi(x,y,u,u_new,u_exact,h,f,error,n,k_j)
		implicit none
		integer :: i,j,k_j
		integer,intent(IN) :: n
		real(8) :: u_new(n,n),error,u(n,n),x(n,n),y(n,n),err_max,err_norm1(n),err_norm2
		real(8),intent(IN):: h,f(n,n),u_exact(n,n)
		open(25,file="data_for_Jacobi.dat")
		u=0.0d0 ! always initialise all the solution vecotors to zero
		u_new=0.0d0	! always initialise all the solution vecotors to zero
		call random_number(u)	!starting from a random guess is always a good choice
		DO i=1,n
    		u(i,1)=0.0d0
    		u(i,n)=0.0d0   	!specifying all the boundary conditions 
    		u(1,i)=0.0d0
    		u(n,i)=0.0d0
   		 END DO
		error=1.0d0		!Specify error=1 so that for the first iteration the IF loop should get executed
		k_j=0
		do 
		k_j=k_j+1			!k is the iteration counter
	  	IF(error>1E-14)THEN
		error=0.0d0		!always initialize error=0.0d0 for each iteration 
		
		do i=2,n-1		!excluding all boundary points becz of BCs
		do j=2,n-1		!excluding all boundary points becoz of BCs

			u_new(i,j)=(1.0d0/4.0d0)*(u(i-1,j)+u(i+1,j)+u(i,j-1)+u(i,j+1)-((h**2)*(f(i,j)))) !new value of u from old value
			error=error+abs((u_new(i,j)-u(i,j))**2) 	!calculating error at each point and summing it over whole domain
		
			
		end do
		end do
		error=sqrt(h*h*error)
		!print*,"Error=",error
		u=u_new			!Replacing the old and new solution vectors
	  ELSEIF(error<1E-14)THEN
  	  EXIT
  	  ENDIF
	END DO
	err_norm1=0.0d0
	err_norm2=0.0d0
	do j=1,n
		do i=1,n
			err_norm1(j)=err_norm1(j)+abs(u_exact(i,j)-u(i,j))
			err_norm2=err_norm2+((u_exact(i,j)-u(i,j))**2)
		end do
	end do
	err_norm2=sqrt(h*h*err_norm2)
	write(78,"(3ES16.8)"),h,maxval(err_norm1),err_norm2
	close(78)
	print*,"Total Number of iterations=",k_j
	do i=1,n
		do j=1,n
				write(25,"(3ES16.8)"),x(i,j),y(i,j),u(i,j) 	!writing all data in to file 
		end do 
	end do
	close(25)
	end subroutine 

	!this subroutine solve the linear system of equations by using GAUSS-SIEDEL METHOD
	subroutine Gauss_Siedel(x,y,u,h,f,error,n,k_gs,u_exact)
	implicit none
		integer :: i,j,k_gs
		integer,intent(IN) :: n
		real(8) :: u_new(n,n),error,u(n,n),x(n,n),y(n,n),err_max,err_norm1(n),err_norm2
		real(8),intent(IN):: h,f(n,n),u_exact(n,n)
		open(26,file="data_for_GS.dat")
		u=0.0d0 ! always initialise all the solution vecotors to zero
		u_new=0.0d0	! always initialise all the solution vecotors to zero
		call random_number(u)	!starting from a random guess is always a good choice
		DO i=1,n
    		u(i,1)=0.0d0
			u(i,n)=0.0d0   	!specifying all the boundary conditions 
			u(1,i)=0.0d0
    		u(n,i)=0.0d0
    	END DO
		error=1.0d0		!Specify error=1 so that for the first iteration the IF loop should get executed
		k_gs=0
		do 
		
	  		IF(error>1E-14)THEN
			error=0.0d0		!always initialize error=0.0d0 for each iteration 
			k_gs=k_gs+1			!k is the iteration counter
			do i=2,n-1		!excluding all boundary points becz of BCs
			do j=2,n-1		!excluding all boundary points becoz of BCs

				u_new(i,j)=(1.0d0/4.0d0)*(u(i-1,j)+u(i+1,j)+u(i,j-1)+u(i,j+1)-((h**2)*(f(i,j)))) !new value of u from old value
				error=error+abs((u_new(i,j)-u(i,j))**2) 				!calculating error at each point and summing it over whole domain
				u(i,j)=u_new(i,j)
			
			end do
			end do
			error=sqrt(h*h*error)
			!print*,"Error=",error
			!u=u_new			!Replacing the old and new solution vectors
	  		ELSEIF(error<1E-14)THEN
  	 		 EXIT
  	  		ENDIF
		END DO
		print*,"Total Number of iterations=",k_gs
		err_norm1=0.0d0
		err_norm2=0.0d0
		do j=1,n
			do i=1,n
				err_norm1(j)=err_norm1(j)+abs(u_exact(i,j)-u(i,j))
				err_norm2=err_norm2+((u_exact(i,j)-u(i,j))**2)
			end do
		end do
		err_norm2=sqrt(h*h*err_norm2)
		
		write(79,"(3ES16.8)"),h,maxval(err_norm1),err_norm2
		close(79)
	do i=1,n
		do j=1,n
				write(26,"(3ES16.8)"),x(i,j),y(i,j),u(i,j) 	!writing all data in to file 
		end do 
	end do
	close(26)
	end subroutine 

	subroutine Gauss_Siedel_Relax(x,y,u,h,f,error,n,pi,k_gsr,u_exact)
	implicit none
		integer :: i,j,k_gsr
		integer,intent(IN) :: n
		real(8) :: u_new(n,n),error,u(n,n),x(n,n),y(n,n),w,err_max,err_norm1(n),err_norm2
		real(8),intent(IN):: h,f(n,n),pi,u_exact(n,n)
		open(27,file="data_for_GS_Relax.dat")
		u=0.0d0 ! always initialise all the solution vecotors to zero
		u_new=0.0d0	! always initialise all the solution vecotors to zero
		w=4.0d0-((cos(pi/(n-1))+cos(pi/(n-1)))**2)
		w=4.0d0/(2.0d0+sqrt(w))
		print*,"W=",w
		call random_number(u)	!starting from a random guess is always a good choice
		DO i=1,n
    		u(i,1)=0.0d0
			u(i,n)=0.0d0   	!specifying all the boundary conditions 
			u(1,i)=0.0d0
    		u(n,i)=0.0d0
    	END DO
		error=1.0d0		!Specify error=1 so that for the first iteration the IF loop should get executed
		k_gsr=0
		do 
		
	  		IF(error>1E-14)THEN
			error=0.0d0		!always initialize error=0.0d0 for each iteration 
			k_gsr=k_gsr+1			!k is the iteration counter
			do i=2,n-1		!excluding all boundary points becz of BCs
			do j=2,n-1		!excluding all boundary points becoz of BCs

				u_new(i,j)=((1.0d0-w)*u(i,j))+((w/4.0d0)*(u(i-1,j)+u(i+1,j)+u(i,j-1)+u(i,j+1)-((h**2)*(f(i,j)))))
																!new value of u from old value
				error=error+abs((u_new(i,j)-u(i,j))**2) 				!calculating error at each point and summing it over whole domain
				u(i,j)=u_new(i,j)
			
			end do
			end do
			error=sqrt(h*h*error)
			!print*,"Error=",error
			!u=u_new			!Replacing the old and new solution vectors
	  		ELSEIF(error<1E-14)THEN
  	 		 EXIT
  	  		ENDIF
		END DO
		print*,"Total Number of iterations=",k_gsr
		err_norm1=0.0d0
		err_norm2=0.0d0
		do j=1,n
			do i=1,n
				err_norm1(j)=err_norm1(j)+abs(u_exact(i,j)-u(i,j))
				err_norm2=err_norm2+((u_exact(i,j)-u(i,j))**2)
				
			end do
		end do
		
		err_norm2=sqrt(h*h*err_norm2)
		
		write(80,"(3ES16.8)"),h,maxval(err_norm1),err_norm2
		close(80)
	do i=1,n
		do j=1,n
				write(27,"(3ES16.8)"),x(i,j),y(i,j),u(i,j) 	!writing all data in to file 
		end do 
	end do
	close(27)
	end subroutine 






















end module calc_subroutine