%Test M-class mapping

clear all

load optdigits.tra
X = optdigits(:, 1:64);
Y = optdigits(:, 65);

newX = zeros(3823*10, 64*10);
newY = zeros(3823 * 10, 1);

m = 1; %newX current row
n = 1; %newX current column

for i=1:3823 %For each point
    for j=1:10 % for each class
        
        if ( j == Y( i ) )
            newY( m ) = +1;
        else
            newY( m ) = -1;
        end
        
        n = 1;
        for k=1:10 %One copy of x at each time
            for l=1:64
                if ( k == j )
                    newX( m, n ) = X( i, l );
                else
                    newX( m, n ) = - X( i, l ); 
                end
                n = n + 1;
            end
        end
        m = m + 1;
    end
end