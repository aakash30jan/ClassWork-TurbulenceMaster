module overloadAdd


        type space
          real(8):: part
        end type space

        interface operator(+)
          procedure addSpace
        end interface

contains

	function addSpace(Y, Z) !result(X)
	  implicit none
          type(space), intent(in), dimension(3,3) :: Y,Z
          !type(space), intent(in), dimension(size(Y,1),size(Y,2)) :: Z
          type(space), dimension(3,3) :: addSpace

          addSpace(:,:)%part = Y(:,:)%part + Z(:,:)%part
          
        end function addSpace


end module overloadAdd
