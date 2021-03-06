! =============================================================================
subroutine rp1(maxmx,meqn,mwaves,maux,mbc,mx,ql,qr,auxl,auxr,wave,s,amdq,apdq)
! =============================================================================
!
! Riemann problems for the 1D Burgers' equation with entropy fix for 
! transonic rarefaction. See "Finite Volume Method for Hyperbolic Problems",
! R. J. LeVeque.

! waves: 1
! equations: 1

! Conserved quantities:
!       1 q
    
    implicit double precision (a-h,o-z)

    integer :: maxmx, meqn, mwaves, mbc, mx   
    double precision :: ql(meqn,1-mbc:maxmx+mbc)
    double precision :: qr(meqn,1-mbc:maxmx+mbc)
    double precision :: s(mwaves, 1-mbc:maxmx+mbc)
    double precision :: wave(meqn, mwaves, 1-mbc:maxmx+mbc)
    double precision :: amdq(meqn, 1-mbc:maxmx+mbc)
    double precision :: apdq(meqn, 1-mbc:maxmx+mbc)
    double precision :: fql, fqr, fqs, fpql, fpqr, fpqs, qs, eps, rhom, gamma
    real(kind=8), external :: fp
    integer :: i
    logical :: efix
 
    efix = .true.   !# Compute correct flux for transonic rarefactions
 	eps = 0.01d0
 	rhom = 0.5d0
 	gamma = 0.5d0 !# Parameter for mollifier approximation

    do i=2-mbc,mx+mbc
        wave(1,1,i) = ql(1,i) - qr(1,i-1)
        call fsub(ql(1,i),fql,fpql,eps,rhom,gamma)
        call fsub(qr(1,i-1),fqr,fpqr,eps,rhom,gamma)

        if (abs(wave(1,1,i)).lt.1e-06) then
            s(1,i) = fpql
        else
            s(1,i) = (fql - fqr) / wave(1,1,i)
        endif

        amdq(1,i) = dmin1(s(1,i), 0.d0) * wave(1,1,i)
        apdq(1,i) = dmax1(s(1,i), 0.d0) * wave(1,1,i)

	    if (efix) then
            if (fpql.gt.0.d0 .and. fpqr.lt.0.d0) then
            	qs = zeroin(ql(1,i),qr(1,i-1),fp,1e-16)
            	call fsub(qs,fqs,fpqs,eps,rhom,gamma)
                amdq(1,i) = fqs - fqr
                apdq(1,i) = fql - fqs
            endif
        endif
    enddo

    return
    end subroutine

!======================================================================
subroutine fsub(q,fq,fpq,eps,rhom,gamma)
!======================================================================
    implicit none
    real(kind=8), intent(in) :: q, eps, rhom, gamma
    real(kind=8), intent(out) :: fq, fpq
    real(kind=8), external :: eta
    double precision :: intl, dx
    integer :: n, i

    n = 500*(int((q-rhom+eps)/eps) + 1) !# mesh cell for integration
    dx = (q-rhom+eps)/n !# mesh size for integration
    intl = 0.d0

    do i = 1,n
    	intl = intl + dx*eta((i-0.5d0)*dx-eps,eps)
    enddo

    fq = q + (gamma-(gamma+1.d0)*q)*intl
    fpq = 1.d0 + (gamma-(gamma+1.d0)*q)*eta(q-rhom,eps) - (gamma+1.d0)*intl
end subroutine fsub



!------------------------------------------------------------------------
real(kind=8) function eta(x,eps)
!------------------------------------------------------------------------
    implicit none
    real(kind=8), intent(in) :: x, eps
    double precision :: C

    C = 2.25228362104358101049978125556d0 !# Constant for integration

    if (abs(x).lt.eps) then
    	eta = C*exp(1.d0/(x**2/eps**2-1.d0))/eps
    else
    	eta = 0.d0
    endif
end function eta

!------------------------------------------------------------------------
real(kind=8) function fp(x)
!------------------------------------------------------------------------
    implicit none
    real(kind=8), external :: eta
    real(kind=8), intent(in) :: x
    double precision :: C, eps, intl, dx, rhom, gamma
    integer :: n,i

    !# Some constants
    rhom = 0.5d0
    gamma = 0.5d0
    eps = 0.01d0
    C = 2.25228362104358101049978125556d0

    !# Start to integrate
    n = 500*(int((x-rhom+eps)/eps) + 1) !# mesh cell for integration
    dx = (x-rhom+eps)/n !# mesh size for integration
    intl = 0.d0
    do i = 1,n
    	intl = intl + dx*eta((i-0.5d0)*dx-eps,eps)
    enddo

    !# Evaluate fp
    fp = 1.d0 + (gamma-(gamma+1.d0)*x)*eta(x-rhom,eps) - (gamma+1.d0)*intl
end function fp