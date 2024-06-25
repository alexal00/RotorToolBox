function xi_NR = MBC(psi,xi_R)
% MBC Multiblade coordinate transfomation as per Coleman [1943]
% Input:
%       * psi : Time history of azimutal position of each blade, [blade, n]
%       * xi_R: Time history of rotating coodinates of each blade, [blade, n]
% Ouput:
%       * xi_NR: Non-rotating coordinates or MBC, [blade, n]
%
% see also rotmat

xi_NR = zeros(size(xi_R));
Nb = size(xi_R,1);
for ii = 1: size(xi_R,2)
    T = rotmat(Nb,psi(:,ii));
    xi_NR(:,ii) = T\xi_R(:,ii);
end

end