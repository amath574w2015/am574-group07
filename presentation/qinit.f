c
c
c =========================================================
       subroutine qinit(meqn,mbc,mx,xlower,dx,q,maux,aux)
c =========================================================
c
c     # Set initial conditions for q.
c
c
      implicit double precision (a-h,o-z)
      dimension q(meqn,1-mbc:mx+mbc)
      dimension aux(maux,1-mbc:mx+mbc)
      common /comic/ beta
c
c
      do 150 i=1,mx
         xcell = xlower + (i-0.5d0)*dx
c         q(1,i) = 0.2d0
         q(1,i) = 0.9d0
         if (xcell.lt.0.d0) then
c             q(1,i) = 0.9d0
c             q(1,i) = 0.4d0
             q(1,i) = 0.2d0
             endif
  150    continue
c
      return
      end

